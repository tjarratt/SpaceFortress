//
//  GLGPlanetoid.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGPlanetoid.h"

@implementation GLGPlanetoid

const CGFloat maximum_mass_before_nuclear_fusion = 9.9945e28;
const CGFloat astronomical_unit = 1.49e11; // mean earth-sun distance

- (id) initWithStar: (GLGSolarStar* ) star {
    if (self = [super init]) {
        CGFloat formation_time = (random() / RAND_MAX) * 200 + 150;
        age = [star age] - formation_time;
        
        CGFloat earth_mass = 7.349e22; // kg
        CGFloat min_mass = earth_mass / 10000;
        CGFloat mass_range = maximum_mass_before_nuclear_fusion - min_mass;
        mass = (random() / RAND_MAX) * mass_range + min_mass;
        
        CGFloat min_radius = 1.5e6;
        CGFloat max_radius = 75e6;
        CGFloat radius_range = max_radius - min_radius;
        radius = (random() / RAND_MAX) * radius_range + min_radius;
        
        CGFloat seconds_day = 86400;
        CGFloat min_axis_rotation = seconds_day * 0.1;
        CGFloat max_axis_rotation = seconds_day * 243.02; // venus
        rotation_around_axis_seconds = (random() / RAND_MAX) * (max_axis_rotation - min_axis_rotation) + min_axis_rotation;

        CGFloat seconds_year = seconds_day * 365.25;
        CGFloat min_body_rotation = seconds_year * 0.2;
        CGFloat max_body_rotation = seconds_year * 350;
        rotation_around_solar_body_seconds = min_body_rotation + (random() / RAND_MAX) * (max_body_rotation + min_body_rotation);

        // completely random for now
        rotation_angle_around_star = (random() / RAND_MAX) * 2 * M_PI;
        
        CGFloat minimum_distance_from_star = 4.619e10;
        CGFloat maximum_distance_from_star = 1.49e13;
        CGFloat range = maximum_distance_from_star - minimum_distance_from_star;
        average_distance_from_star = (random() / RAND_MAX) * (range) + minimum_distance_from_star;
        
        CGFloat perogee_max = average_distance_from_star * 1.5 * (random() / RAND_MAX);
        CGFloat apogee_max = average_distance_from_star * 0.9 * (random() / RAND_MAX);
        CGFloat perogee_min = average_distance_from_star * 1.1 * (random() / RAND_MAX);
        CGFloat apogee_min = average_distance_from_star * 0.5 * (random() / RAND_MAX);
        perogee_meters = (random() / RAND_MAX) * (perogee_max - perogee_min) + perogee_min;
        apogee_meters = (random() / RAND_MAX) * (apogee_max - apogee_min) + apogee_min;

        average_emissivity = random() / RAND_MAX;
        average_albedo = random() / RAND_MAX;
        CGFloat stefan_boltzmann_constant = 5.67e-8;
        surface_temperature = 0.5 * [star luminosity] * (1 - average_albedo) / (4 * M_PI * pow(average_distance_from_star, 2) * average_emissivity * stefan_boltzmann_constant);
        
        has_water = NO;
        has_atmosphere = NO;
        has_magnetic_field = NO;
        
        if (false) {
            has_water = YES;
            has_atmosphere = YES;
        }
    }
    
    return self;
}

- (NSString *)ageInBillionsOfYears {
    return [NSString stringWithFormat:@"%f billions of years old", age];
}

- (float) wattsSolarEnergyPerSquareMeter {
    return (float)0;
}

@end
