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
        star = theStar;
        CGFloat formation_time = [RangeProperty randomValueWithMinimum:150 maximum:350];
        [self setAge:([star age] - formation_time)];
        
        CGFloat seconds_day = 86400;
        CGFloat min_axis_rotation = seconds_day * 0.1;
        CGFloat max_axis_rotation = seconds_day * 243.02; // venus
        rotationAroundAxisSeconds = [RangeProperty randomValueWithMinimum:min_axis_rotation maximum:max_axis_rotation];

        CGFloat seconds_year = seconds_day * 365.25;
        CGFloat min_body_rotation = seconds_year * 0.2;
        CGFloat max_body_rotation = seconds_year * 350;
        rotationAroundSolarBodySeconds = [RangeProperty randomValueWithMinimum:min_body_rotation maximum:max_body_rotation];

        // completely random for now -> but this should be ~ delta a standard value for the system, right?
        rotationAngleAroundStar = [RangeProperty randomValueWithMinimum:-0.5 * M_PI_4 maximum:M_PI_4 * 0.5];
        
        CGFloat minimum_distance_from_star = 4.619e10;
        CGFloat maximum_distance_from_star = 1.49e13;
        averageDistanceFromStar = [RangeProperty randomValueWithMinimum:minimum_distance_from_star maximum:maximum_distance_from_star];
        
        CGFloat perogee_max = averageDistanceFromStar * 1.3;
        CGFloat apogee_max = averageDistanceFromStar * 0.9;
        CGFloat perogee_min = averageDistanceFromStar * 0.8;
        CGFloat apogee_min = averageDistanceFromStar * 0.5;
        
        perogeeMeters = [RangeProperty randomValueWithMinimum:perogee_min maximum:perogee_max];
        apogeeMeters = [RangeProperty randomValueWithMinimum:apogee_min maximum:apogee_max];

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

@end
