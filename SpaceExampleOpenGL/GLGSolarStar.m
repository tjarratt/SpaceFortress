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
@synthesize habitableZoneInnerRadius, habitableZoneOuterRadius;

// constants
const CGFloat chandrasekharLimit = 2.864e30;

// constants for SOL
const CGFloat solarAge = 4.57e9;
const CGFloat solarMass = 1.989e30;
const CGFloat solarRadius = 6.96e5;
const CGFloat solarSurfaceTemperature = 5887;
const CGFloat solarRotationRate = 2592000; // 25-30 earth days
const CGFloat solarMetallicity = 0; // or 1.2% by ratio of H + He to remaining

- (id) init {
    if (self = [super init]) {
        classification = @"";
        age = [RangeProperty randomValueWithMinimum:1 maximum:11];
        mass = [RangeProperty randomValueWithMinimum:1.76e29 maximum:(264 * solarMass)];
        radius = [RangeProperty randomValueWithMinimum:(0.13 * solarRadius) maximum:18 * solarRadius];
        surfaceTemperature = [RangeProperty randomValueWithMinimum:1000 maximum:(50000)];
        rotationRateSeconds = [RangeProperty randomValueWithMinimum:1e-5 maximum:(150 * solarRotationRate)];
        
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
    int rangeBetween;
    NSString *primaryClass, *spectrumRange, *luminosityClass;
    
    // for short distances (ie: within the same galaxy, this is the real distance eg: euclidean)
    // for greater distances, you need to take into account general relativity (redshift affects large distances)
    CGFloat luminosityDistanceLightYears = (random() / RAND_MAX) * 20;
    CGFloat luminosityDistanceParsecs = luminosityDistanceLightYears / 3.26;

    // http://www.astro.wisc.edu/~dolan/constellations/extra/brightest.html
    // http://en.wikipedia.org/wiki/Apparent_magnitude#Calculations
    CGFloat apparentMagnitude = (random() / RAND_MAX) * 3 - 1.5;
    
    CGFloat absoluteMagnitude = apparentMagnitude - 5 * (log10f(luminosityDistanceParsecs) - 1);
    if (absoluteMagnitude < -7.5) {
        luminosityClass = @"0";
    }
    else if (absoluteMagnitude < 6.25) {
        luminosityClass = @"Ia";
    }
    else if (absoluteMagnitude < -5) {
        
        luminosityClass = @"Ib";
    }
    else if (absoluteMagnitude < -2.5) {
        luminosityClass = @"II";
    }
    else if (absoluteMagnitude < 0) {
        luminosityClass = @"III";
    }
    else if (absoluteMagnitude < 2.5) {
        luminosityClass = @"IV";
    }
    else if (absoluteMagnitude < 8) {
        luminosityClass = @"V";
    }
    else if (absoluteMagnitude < 10) {
        luminosityClass = @"VI";
    }
    else {
        luminosityClass = @"VII";
    }

    if (surfaceTemperature >= 33000) {
        primaryClass = @"O";
        rangeBetween = (100000 - surfaceTemperature) / 7000;
        color = [NSColor colorWithDeviceRed:0.92 green:0.94 blue:1.0 alpha:1.0];
    }
    else if (surfaceTemperature >= 10000) {
        primaryClass = @"B";
        rangeBetween = (33000 - surfaceTemperature) / 2300;
        color = [NSColor colorWithDeviceRed:0.89 green:0.91 blue:1.0 alpha:1.0];
    }
    else if (surfaceTemperature >= 7500) {
        primaryClass = @"A";
        rangeBetween = (10000 - surfaceTemperature) / (10000 - 7500);
        color = [NSColor colorWithDeviceRed:0.788 green:0.807 blue:0.866 alpha:1.0];
    }
    else if (surfaceTemperature >= 6000) {
        primaryClass = @"F";
        rangeBetween = (7500 - surfaceTemperature) / 1500;
        color = [NSColor colorWithDeviceRed:1 green:1 blue:.73 alpha:1];
    }
    else if (surfaceTemperature >= 5200) {
        primaryClass = @"G";
        rangeBetween = (6000 - surfaceTemperature) / 800;
        color = [NSColor colorWithDeviceRed:1 green:1 blue:.62 alpha:1];
    }
    else if (surfaceTemperature >= 3700) {
        primaryClass = @"K";
        rangeBetween = (5200 - surfaceTemperature) / 500;
        color = [NSColor colorWithDeviceRed:.98 green:.79 blue:.42 alpha:1];
    }
    else if (surfaceTemperature >= 2000) {
        primaryClass = @"M";
        rangeBetween = (3700 - surfaceTemperature) / 1700;
        color = [NSColor colorWithDeviceRed:0.8 green:0.36 blue:0.19 alpha:1];
    }
    else if (surfaceTemperature >= 1300) {
        primaryClass = @"L";
        rangeBetween = (2000 - surfaceTemperature) / 700;
        color = [NSColor colorWithDeviceRed:0.72 green:0.04 blue:0.04 alpha:1];
    }
    else if (surfaceTemperature >= 700) {
        primaryClass = @"T";
        rangeBetween = (1300 - surfaceTemperature) / 600;
        color = [NSColor colorWithDeviceRed:0.37 green:0.05 blue:0.21 alpha:1];
    }
    else {
        primaryClass = @"Y";
        rangeBetween = (700 - surfaceTemperature) / 100;
        color = [NSColor colorWithDeviceRed:0.21 green:0.16 blue:0.23 alpha:1];
    }
    
    [color retain];
    spectrumRange = [NSString stringWithFormat:@"%d", rangeBetween];
    classification = [NSString stringWithFormat:@"%@%@%@", primaryClass, spectrumRange, luminosityClass];
}

// units are in Watts (Joules / second)
- (CGFloat) luminosity {
    const CGFloat boltzman = 5.67e-8;
    return 4 * M_PI * pow(radius, 2) * pow(surfaceTemperature, 4) * boltzman;
}

// units are in meters per second
- (CGFloat) escapeVelocity {
    const CGFloat gravitationConstant = 6.67e-11;
    return pow(2 * gravitationConstant * mass / radius, 0.5f);
}

- (void) describe {
    NSLog(@"I am just a simple %@ star, radiating at %fK", classification, surfaceTemperature);
    NSLog(@"My solar mass is %f", mass);
    NSLog(@"My age is %@", [self ageInYears]);
    NSLog(@"My solar radius is %f", radius);
}

- (NSString *) radiusAsMeters {
    return [NSString stringWithFormat:@"%f meters", radius];
}

#pragma mark - percentage comparison to SOL
- (NSString *) radiusComparison {
    return [NSString stringWithFormat: @"%f", radius * 100 / solarRadius];
}

- (NSString *) massComparison {
    return [NSString stringWithFormat: @"%f", mass * 100 / solarMass];
}

- (NSString *) surfaceTemperatureComparison {
    return [NSString stringWithFormat: @"%f", surfaceTemperature * 100 / solarSurfaceTemperature];
}

- (NSString *) metallicityComparison {
    return [NSString stringWithFormat: @"%f", metallicity];
}

@end
