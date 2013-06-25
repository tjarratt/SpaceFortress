//
//  GLGSolarStar.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGSolarStar.h"

@implementation GLGSolarStar

@synthesize age;

// constants
const CGFloat chandrasekhar_limit = 2.864e30;

// constants for SOL
const CGFloat solar_age = 4.57e9;
const CGFloat solar_mass = 1.989e30;
const CGFloat solar_radius = 6.96e5;
const CGFloat solar_surface_temperature = 5887;
const CGFloat solar_rotation_rate = 2592000; // 25-30 earth days
const CGFloat solar_metallicity = 0; // or 1.2% by ratio of H + He to remaining

- (id) init {
    if (self = [super init]) {
        age = [RangeProperty randomValueWithMinimum:1 maximum:11];
        mass = [RangeProperty randomValueWithMinimum:1.76e29 maximum:(264 * solar_mass)];
        radius = [RangeProperty randomValueWithMinimum:(0.13 * solar_radius) maximum:18];
        surface_temperature = [RangeProperty randomValueWithMinimum:1000 maximum:(13 * solar_surface_temperature)];
        rotation_rate_in_seconds = [RangeProperty randomValueWithMinimum:1e-5 maximum:(150 * solar_rotation_rate)];
        
        // metallicity: 0.0122 ( or 1.2 %)
        // this represents the actual percentage of non H, He in the sun, but
        // this value is common represented as log10(Fe / H) for the star - log10(Fe / H) for our sun
        // a range of -2, 2 is fairly common for "habitable star systems"
        metallicity = [RangeProperty randomValueWithMinimum: -2 maximum: 2];
    }

    return self;
}

- (NSString *) ageInYears {
    return [NSString stringWithFormat:@"%f billions of years old", age];
}

- (NSString *) spectralClassification {
    int range_between;
    NSString *primary_class, *spectrum_range, *luminosity_class;
    
    // for short distances (ie: within the same galaxy, this is the real distance eg: euclidean)
    // for greater distances, you need to take into account general relativity (redshift affects large distances)
    CGFloat luminosity_distance_light_years = (random() / RAND_MAX) * 20;
    CGFloat luminosity_distance_parsecs = luminosity_distance_light_years / 3.26;

    // http://www.astro.wisc.edu/~dolan/constellations/extra/brightest.html
    // http://en.wikipedia.org/wiki/Apparent_magnitude#Calculations
    CGFloat apparent_magnitude = (random() / RAND_MAX) * 3 - 1.5;
    
    CGFloat absolute_magnitude = apparent_magnitude - 5 * (log10f(luminosity_distance_parsecs) - 1);
    if (absolute_magnitude < -7.5) {
        luminosity_class = @"0";
    }
    else if (absolute_magnitude < 6.25) {
        luminosity_class = @"Ia";
    }
    else if (absolute_magnitude < -5) {
        luminosity_class = @"Ib";
    }
    else if (absolute_magnitude < -2.5) {
        luminosity_class = @"II";
    }
    else if (absolute_magnitude < 0) {
        luminosity_class = @"III";
    }
    else if (absolute_magnitude < 2.5) {
        luminosity_class = @"IV";
    }
    else if (absolute_magnitude < 8) {
        luminosity_class = @"V";
    }
    else if (absolute_magnitude < 10) {
        luminosity_class = @"VI";
    }
    else {
        luminosity_class = @"VII";
    }

    if (surface_temperature >= 33000) {
        primary_class = @"O";
        range_between = (100000 - surface_temperature) / 7000;
    }
    else if (surface_temperature >= 10000) {
        primary_class = @"B";
        range_between = (33000 - surface_temperature) / 2300;
    }
    else if (surface_temperature >= 7500) {
        primary_class = @"A";
        range_between = (10000 - surface_temperature) / (10000 - 7500);
    }
    else if (surface_temperature >= 6000) {
        primary_class = @"F";
        range_between = (7500 - surface_temperature) / 1500;
    }
    else if (surface_temperature >= 5200) {
        primary_class = @"G";
        range_between = (6000 - surface_temperature) / 800;
    }
    else if (surface_temperature >= 3700) {
        primary_class = @"K";
        range_between = (5200 - surface_temperature) / 500;
    }
    else if (surface_temperature >= 2000) {
        primary_class = @"M";
        range_between = (3700 - surface_temperature) / 1700;
    }
    else if (surface_temperature >= 1300) {
        primary_class = @"L";
        range_between = (2000 - surface_temperature) / 700;
    }
    else if (surface_temperature >= 700) {
        primary_class = @"T";
        range_between = (1300 - surface_temperature) / 600;
    }
    else {
        primary_class = @"Y";
        range_between = (700 - surface_temperature) / 100;
    }
    
    spectrum_range = [NSString stringWithFormat:@"%d", range_between];
    return [NSString stringWithFormat:@"%@%@%@", primary_class, spectrum_range, luminosity_class];
}

// units are in Watts (Joules / second)
- (CGFloat) luminosity {
    const CGFloat boltzman = 5.67e-8;
    return 4 * M_PI * pow(radius, 2) * pow(surface_temperature, 4) * boltzman;
}

// units are in meters per second
- (CGFloat) escapeVelocity {
    const CGFloat gravitation_constant = 6.67e-11;
    return pow(2 * gravitation_constant * mass / radius, 0.5f);
}

- (void) describe {
    NSLog(@"I am just a simple star");
}

@end
