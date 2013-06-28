//
//  GLGPlanetoid.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGPlanetoid.h"

@implementation GLGPlanetoid

@synthesize age, mass, name, radius, color;
@synthesize perogeeMeters, apogeeMeters;
@synthesize rotationAngleAroundStar;

const CGFloat maximum_mass_before_nuclear_fusion = 9.9945e28;
const CGFloat astronomical_unit = 1.49e11; // mean earth-sun distance

- (id) initWithStar: (GLGSolarStar* ) star {
    if (self = [super init]) {
        name = [NameProperty randomName];
        
        CGFloat formation_time = [RangeProperty randomValueWithMinimum:150 maximum:350];
        age = [star age] - formation_time;
        
        CGFloat earth_mass = 7.349e22; // kg
        CGFloat min_mass = earth_mass / 10000;
        mass = [RangeProperty randomValueWithMinimum:min_mass maximum:maximum_mass_before_nuclear_fusion];
        
        CGFloat min_radius = 1.5e6;
        CGFloat max_radius = 75e6;
        radius = [RangeProperty randomValueWithMinimum:min_radius maximum:max_radius];
        
        CGFloat seconds_day = 86400;
        CGFloat min_axis_rotation = seconds_day * 0.1;
        CGFloat max_axis_rotation = seconds_day * 243.02; // venus
        rotationAroundAxisSeconds = [RangeProperty randomValueWithMinimum:min_axis_rotation maximum:max_axis_rotation];

        CGFloat seconds_year = seconds_day * 365.25;
        CGFloat min_body_rotation = seconds_year * 0.2;
        CGFloat max_body_rotation = seconds_year * 350;
        rotationAroundSolarBodySeconds = [RangeProperty randomValueWithMinimum:min_body_rotation maximum:max_body_rotation];

        // completely random for now -> but this should be ~ delta a standard value for the system, right?
        rotationAngleAroundStar = [RangeProperty randomValueWithMinimum:-1 * M_PI_4 maximum:M_PI_4];
        
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
    return [[NSString stringWithFormat:@"%e kilograms", mass] stringByReplacingOccurrencesOfString:@"e+" withString:@" * 10^"];
}

- (NSString *)ageInBillionsOfYears {
    return [[NSString stringWithFormat:@"%e billions of years old", age] stringByReplacingOccurrencesOfString:@"e+" withString:@" * 10^"];
}

- (NSString *)friendlyRadius {
    return [[NSString stringWithFormat:@"%e meters", radius] stringByReplacingOccurrencesOfString:@"e+" withString:@" * 10^"];
}

// xxx implement me correctly using radius + distance from body + luminosity + all those things
- (float) wattsSolarEnergyPerSquareMeter {
    return (float)0;
}

- (void) describe {
    NSLog(@"I am just a simple planetoid: %@", [self name]);
    NSLog(@"I am %@", [self ageInBillionsOfYears]);
    NSLog(@"My mass is %@, my radius is %@", [self friendlyMass], [self friendlyRadius]);
    NSLog(@"My rotation angle around my star is %f", rotationAngleAroundStar);
    NSLog(@"My color is (%f, %f, %f)", color.redComponent, color.greenComponent, color.blueComponent);
}

@end
