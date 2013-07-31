//
//  GLGPlanetoid.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGPlanetoid.h"

@implementation GLGPlanetoid

@synthesize perogeeMeters, apogeeMeters;
@synthesize rotationAngleAroundStar, rotationAroundAxisSeconds, rotationAroundSolarBodySeconds;
@synthesize density;

- (id) initWithStar: (GLGSolarStar* ) theStar {
    if (self = [super init]) {
        tickNumber = 0;
        trailers = [[NSMutableArray alloc] initWithCapacity:0];

        star = theStar;
        CGFloat formation_time = [GLGRangeProperty randomValueWithMinimum:150 maximum:350];
        [self setAge:([star age] - formation_time)];

        CGFloat earth_mass = 7.349e22; // kg
        CGFloat min_mass = earth_mass / 10000;
        [self setMass:[GLGRangeProperty randomValueWithMinimum:min_mass maximum:maximumMassBeforeNuclearFusion]];

        CGFloat min_radius = 1.5e6;
        CGFloat max_radius = 75e6;
        [self setRadius: [GLGRangeProperty randomValueWithMinimum:min_radius maximum:max_radius]];

        CGFloat seconds_day = 86400;
        CGFloat min_axis_rotation = seconds_day * 0.1;
        CGFloat max_axis_rotation = seconds_day * 243.02; // venus
        rotationAroundAxisSeconds = [GLGRangeProperty randomValueWithMinimum:min_axis_rotation maximum:max_axis_rotation];

        CGFloat seconds_year = seconds_day * 365.25;
        CGFloat min_body_rotation = seconds_year * 0.2;
        CGFloat max_body_rotation = seconds_year * 350;
        rotationAroundSolarBodySeconds = [GLGRangeProperty randomValueWithMinimum:min_body_rotation*20 maximum:max_body_rotation] * 2;

        rotationAngleAroundStar = [GLGRangeProperty randomValueWithMinimum:-0.5 * M_PI_4 maximum:M_PI_4 * 0.5];
        
        CGFloat minimum_distance_from_star = 4.619e10;
        CGFloat maximum_distance_from_star = 1.49e13;
        averageDistanceFromStar = [GLGRangeProperty randomValueWithMinimum:minimum_distance_from_star maximum:maximum_distance_from_star];
        
        CGFloat perogee_max = averageDistanceFromStar * 1.3;
        CGFloat apogee_max = averageDistanceFromStar * 0.9;
        CGFloat perogee_min = averageDistanceFromStar * 0.8;
        CGFloat apogee_min = averageDistanceFromStar * 0.5;
        
        perogeeMeters = [GLGRangeProperty randomValueWithMinimum:perogee_min maximum:perogee_max];
        apogeeMeters = [GLGRangeProperty randomValueWithMinimum:apogee_min maximum:apogee_max];

        averageEmissivity = random() / RAND_MAX;
        averageAlbedo = random() / RAND_MAX;
        CGFloat stefan_boltzmann_constant = 5.67e-8;
        surfaceTemperature = 0.5 * [star luminosity] * (1 - averageAlbedo) / (4 * M_PI * pow(averageDistanceFromStar, 2) * averageEmissivity * stefan_boltzmann_constant);
        
        hasWater = NO;
        hasAtmosphere = NO;
        hasMagneticField = NO;
        
        if (false) {
            hasWater = YES;
            hasAtmosphere = YES;
        }
    }
    
    return self;
}

- (NSString *)friendlyMass {
    return [[NSString stringWithFormat:@"%e kilograms", [self mass]] stringByReplacingOccurrencesOfString:@"e+" withString:@" * 10^"];
}

- (NSString *)ageInBillionsOfYears {
    return [[NSString stringWithFormat:@"%e billions of years old", [self age]] stringByReplacingOccurrencesOfString:@"e+" withString:@" * 10^"];
}

- (NSString *)friendlyRadius {
    return [[NSString stringWithFormat:@"%e meters", [self radius]] stringByReplacingOccurrencesOfString:@"e+" withString:@" * 10^"];
}

- (CGFloat) wattsSolarEnergyPerSquareMeter {
    CGFloat surfaceAreaLuminosity = 4 * M_PI * powf(averageDistanceFromStar, 2);
    return star.luminosity / surfaceAreaLuminosity;
}

- (CGFloat) earthSimilarityIndex {
    CGFloat radiusComponent = powf(1 - ([self radius] - earthRadius) / ([self radius] + earthRadius), 0.57f);
    CGFloat densityComponent = powf(1 - ([self density] - earthDensity) / ([self density] + earthDensity), 1.07f);
    CGFloat escapeVelocityComponent = powf(1 - ([self escapeVelocity] - earthEscapeVelocity) / ([self escapeVelocity] + earthEscapeVelocity), 0.70f);
    CGFloat surfaceTemperatureComponent = powf(1 - (surfaceTemperature - earthSurfaceTemperature) / (surfaceTemperature + earthSurfaceTemperature), 5.58f);
    
    return radiusComponent * densityComponent * escapeVelocityComponent * surfaceTemperatureComponent;
}

- (NSMutableArray *) trailers {
    return trailers;
}

- (void) tick {
    if (tickNumber < 100) {
        if (tickNumber % 10 == 0) {
            int n = (int) ceilf(tickNumber / 10.0);

            GLGPsychedeliaTrailer *t = [[GLGPsychedeliaTrailer alloc] init];
            NSColor *color;

            switch(n) {
                case 0:
                    color = [NSColor colorWithDeviceRed:0.996 green:0.1647 blue:0 alpha:1.0];
                    break;
                case 1:
                    color = [NSColor colorWithDeviceRed:0.8078 green:0.545 blue:0.5176 alpha:1.0];
                    break;
                case 2:
                    color = [NSColor colorWithDeviceRed:0.0274 green:0.8156 blue:0.71372 alpha:1.0];
                    break;
                case 3:
                    color = [NSColor colorWithDeviceRed:0.9921 green:0.6745 blue:0 alpha:1.0];
                    break;
                case 4:
                    color = [NSColor colorWithDeviceRed:0.08235 green:0.96862 blue:0.55294 alpha:1.0];
                    break;
                case 5:
                    color = [NSColor colorWithDeviceRed:0.62745 green:0 blue:0.25098 alpha:1.0];
                    break;
                case 6:
                    color = [NSColor colorWithDeviceRed:0.99607 green:0.341176 blue:0.48627 alpha:1.0];
                    break;
                case 7:
                    color = [NSColor colorWithDeviceRed:0.98431 green:0 blue:0.1294117 alpha:1.0];
                    break;
                case 8:
                    color = [NSColor colorWithDeviceRed:0.039215 green:0.913725 blue:0.709803 alpha:1.0];
                    break;
                case 9:
                    color = [NSColor colorWithDeviceRed:0.992156 green:0 blue:0.52156 alpha:1.0];
                    break;
            }

            [t setColor:color];
            [trailers insertObject:t atIndex:n];
            [t release];
        }
    }
    else {
        // handle the case where tick > 100
        // we probably need to start phasing one out
        if (tickNumber % 10 == 0) {
            NSColor *lastColor = [[[trailers objectAtIndex:0] color] copy];
            for (int i = 0; i < 9; ++i) {
                [[trailers objectAtIndex:i] setColor:[[trailers objectAtIndex:(i+1)] color]];
            }
            [[trailers objectAtIndex:9] setColor:lastColor];
        }
    }

    ++tickNumber;
}

@end
