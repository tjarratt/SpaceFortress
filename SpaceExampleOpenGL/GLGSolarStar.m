//
//  GLGSolarStar.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGSolarStar.h"

@implementation GLGSolarStar

@synthesize age, color, radius;

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
        classification = @"";
        age = [RangeProperty randomValueWithMinimum:1 maximum:11];
        mass = [RangeProperty randomValueWithMinimum:1.76e29 maximum:(264 * solar_mass)];
        radius = [RangeProperty randomValueWithMinimum:(0.13 * solar_radius) maximum:18 * solar_radius];
        surface_temperature = [RangeProperty randomValueWithMinimum:1000 maximum:(50000)];
        rotation_rate_in_seconds = [RangeProperty randomValueWithMinimum:1e-5 maximum:(150 * solar_rotation_rate)];
        
        // metallicity: 0.0122 ( or 1.2 %)
        // this represents the actual percentage of non H, He in the sun, but
        // this value is common represented as log10(Fe / H) for the star - log10(Fe / H) for our sun
        // a range of -2, 2 is fairly common for "habitable star systems"
        metallicity = [RangeProperty randomValueWithMinimum: -2 maximum: 2];
        
        // calculate spectral classification and color
        [self calculateSpectralClassification];
    }

    return self;
}

- (NSString *) ageInYears {
    return [NSString stringWithFormat:@"%f billions of years old", age];
}

- (NSString *) spectralClassification {
    return classification;
}

- (void) calculateSpectralClassification {
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
        color = [NSColor colorWithDeviceRed:0.92 green:0.94 blue:1.0 alpha:1.0];
    }
    else if (surface_temperature >= 10000) {
        primary_class = @"B";
        range_between = (33000 - surface_temperature) / 2300;
        color = [NSColor colorWithDeviceRed:0.89 green:0.91 blue:1.0 alpha:1.0];
    }
    else if (surface_temperature >= 7500) {
        primary_class = @"A";
        range_between = (10000 - surface_temperature) / (10000 - 7500);
        color = [NSColor colorWithDeviceRed:0.788 green:0.807 blue:0.866 alpha:1.0];
    }
    else if (surface_temperature >= 6000) {
        primary_class = @"F";
        range_between = (7500 - surface_temperature) / 1500;
        color = [NSColor colorWithDeviceRed:1 green:1 blue:.73 alpha:1];
    }
    else if (surface_temperature >= 5200) {
        primary_class = @"G";
        range_between = (6000 - surface_temperature) / 800;
        color = [NSColor colorWithDeviceRed:1 green:1 blue:.62 alpha:1];
    }
    else if (surface_temperature >= 3700) {
        primary_class = @"K";
        range_between = (5200 - surface_temperature) / 500;
        color = [NSColor colorWithDeviceRed:.98 green:.79 blue:.42 alpha:1];
    }
    else if (surface_temperature >= 2000) {
        primary_class = @"M";
        range_between = (3700 - surface_temperature) / 1700;
        color = [NSColor colorWithDeviceRed:0.8 green:0.36 blue:0.19 alpha:1];
    }
    else if (surface_temperature >= 1300) {
        primary_class = @"L";
        range_between = (2000 - surface_temperature) / 700;
        color = [NSColor colorWithDeviceRed:0.72 green:0.04 blue:0.04 alpha:1];
    }
    else if (surface_temperature >= 700) {
        primary_class = @"T";
        range_between = (1300 - surface_temperature) / 600;
        color = [NSColor colorWithDeviceRed:0.37 green:0.05 blue:0.21 alpha:1];
    }
    else {
        primary_class = @"Y";
        range_between = (700 - surface_temperature) / 100;
        color = [NSColor colorWithDeviceRed:0.21 green:0.16 blue:0.23 alpha:1];
    }
    
    [color retain];
    spectrum_range = [NSString stringWithFormat:@"%d", range_between];
    classification = [NSString stringWithFormat:@"%@%@%@", primary_class, spectrum_range, luminosity_class];
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
    NSLog(@"I am just a simple %@ star, radiating at %fK", classification, surface_temperature);
    NSLog(@"My solar mass is %f", mass);
    NSLog(@"My age is %@", [self ageInYears]);
    NSLog(@"My solar radius is %f", radius);
}

- (NSString *) radius_as_meters {
    return [NSString stringWithFormat:@"%f meters", radius];
}

#pragma mark - percentage comparison to SOL
- (CGFloat) radius_comparison {
    return radius * 100 / solar_radius;
}

- (CGFloat) mass_comparison {
    return mass * 100 / solar_mass;
}

- (CGFloat) surface_temperature_comparison {
    return surface_temperature * 100 / solar_surface_temperature;
}

- (CGFloat) metallicity_comparison {
    return metallicity;
}

@end
