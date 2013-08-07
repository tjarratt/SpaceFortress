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

- (id) initAsSol {
    if (self = [super init]) {
        luminosityClass = @"G";
        
        classification = @"G2V";
        age = solarAge;
        [self setMass:solarMass];
        radius = solarRadius;
        surfaceTemperature = solarSurfaceTemperature;
        rotationRateSeconds = solarRotationRate;
        metallicity = solarMetallicity;

        [self calculateSpectralClassification];
        apparentMagnitude = -26.74;
        absoluteMagnitude = 4.83;

        habitableZoneInnerRadius = astronomicalUnit * 0.97;
        habitableZoneOuterRadius = astronomicalUnit * 1.688;
    }

    return self;
}

- (id) init {
    if (self = [super init]) {
        classification = @"";
        age = [GLGRangeProperty randomValueWithMinimum:minimumSolarAge maximum:maximumSolarAge];
        [self setMass:[GLGRangeProperty randomValueWithMinimum:minimumSolarMass maximum:maximumSolarMass] ];
        radius = [GLGRangeProperty randomValueWithMinimum:minimumSolarRadius maximum:maximumSolarRadius];
        surfaceTemperature = [GLGRangeProperty randomValueWithMinimum:minimumSolarSurfaceTemperature maximum:maximumSolarSurfaceTemperature];
        rotationRateSeconds = [GLGRangeProperty randomValueWithMinimum:minimumSolarRotationRate maximum:maximumSolarRotationRate];
        
        // metallicity: 0.0122 ( or 1.2 %)
        // this represents the actual percentage of non H, He in the sun, but
        // this value is common represented as log10(Fe / H) for the star - log10(Fe / H) for our sun
        // a range of -2, 2 is fairly common for "habitable star systems"
        metallicity = [GLGRangeProperty randomValueWithMinimum:minimumSolarMetallicity maximum:maximumSolarMetallicity];
        
        // calculate spectral classification and color
        [self calculateSpectralClassification];
        
        // calculate habitable zone
        // Mv -> absolute magnitude == mv - 5 * log(d / 10)
        // mv -> apparent magnitude
        // d  -> distance from planet to star

        // Mbol -> bolometric magnitude = Mv + BC
        // BC   -> bolometric correction constant (table for spectral classes)
        // B:-2   A:-0.3   F:-0.15   G:-0.4   K:-0.8   M:-2.0

        // absolute luminosity of the star
        // Lstar / Lsun = 10 ^^ ( (Mbolstar - Mbolsun) / -2.5 )

        // ri = sqrt(Lstar/Lsun / 1.1)
        // ro = sqrt(Lstar/Lsun / 0.53)
        
        // http://arxiv.org/pdf/1212.0928.pdf
        // http://en.wikipedia.org/wiki/Bolometric_correction
        // http://www.planetarybiology.com/calculating_habitable_zone.htm
        // nb: there is very little agreement on the Bolometric Correction Constants
        CGFloat bolometricCorrectionConstant = 0;
        if ([luminosityClass isEqualToString:@"O"]) {
            bolometricCorrectionConstant = -4.3;
        }
        else if ([luminosityClass isEqualToString:@"B"]) {
            bolometricCorrectionConstant = -2.0f;
        }
        else if ([luminosityClass isEqualToString:@"A"]) {
            bolometricCorrectionConstant = -0.3f;
        }
        else if ([luminosityClass isEqualToString:@"F"]) {
            bolometricCorrectionConstant = -0.15f;
        }
        else if ([luminosityClass isEqualToString:@"G"]) {
            bolometricCorrectionConstant = -0.4f;
        }
        else if ([luminosityClass isEqualToString:@"K"]) {
            bolometricCorrectionConstant = -0.8f;
        }
        else {
            bolometricCorrectionConstant = -4.0;
        }
        
        CGFloat bolometricMagnitude = absoluteMagnitude + bolometricCorrectionConstant;
        
        CGFloat absoluteLuminosityRelativeToTheSun = pow(10, (bolometricMagnitude - solarBolometricMagnitude) / -2.5f);
        habitableZoneInnerRadius = sqrt(absoluteLuminosityRelativeToTheSun / 1.1f) * astronomicalUnit;
        habitableZoneOuterRadius = sqrt(absoluteLuminosityRelativeToTheSun / 0.53f) * astronomicalUnit;
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
    NSString *spectrumRange;
    
    // for short distances (ie: within the same galaxy, this is the real distance eg: euclidean)
    // for greater distances, you need to take into account general relativity (redshift affects large distances)
    CGFloat luminosityDistanceLightYears = [GLGRangeProperty randomValueWithMinimum:0 maximum:20];
    CGFloat luminosityDistanceParsecs = luminosityDistanceLightYears / 3.26;

    // http://www.astro.wisc.edu/~dolan/constellations/extra/brightest.html
    // http://en.wikipedia.org/wiki/Apparent_magnitude#Calculations
    apparentMagnitude = [GLGRangeProperty randomValueWithMinimum:minimumSolarAppMagnitude maximum:maximumSolarAppMagnitude];
    absoluteMagnitude = apparentMagnitude - 5 * (log10f(luminosityDistanceParsecs) - 1);
    
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

    spectrumRange = [NSString stringWithFormat:@"%d", rangeBetween];
    classification = [NSString stringWithFormat:@"%@%@%@", primaryClass, spectrumRange, luminosityClass];

    [color retain];
    [classification retain];
}

// units are in Watts (Joules / second)
- (CGFloat) luminosity {
    const CGFloat boltzman = 5.67e-8;
    return 4 * M_PI * powf(radius, 2) * powf(surfaceTemperature, 4) * boltzman;
}

- (NSString *) radiusAsMeters {
    return [NSString stringWithFormat:@"%f meters", radius];
}

- (CGFloat) apparentMagnitude {
    return apparentMagnitude;
}

- (CGFloat) surfaceTemperature {
    return surfaceTemperature;
}

- (CGFloat) rotationRate {
    return rotationRateSeconds;
}

- (CGFloat) radius {
    return radius;
}

- (NSString *) habitableZoneRange {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    [formatter setNumberStyle:NSNumberFormatterScientificStyle];

    NSString *inner = [formatter stringFromNumber:[NSNumber numberWithFloat:habitableZoneInnerRadius]];
    NSString *outer = [formatter stringFromNumber:[NSNumber numberWithFloat:habitableZoneOuterRadius]];

    NSString *range = [[inner stringByAppendingString:@"-"] stringByAppendingString:outer];
    [formatter release];

    return range;
}

- (CGFloat) metallicity {
    return metallicity;
}

#pragma mark - range methods
+ (GLGFloatPair *) metallicityRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarMetallicity andFloat:maximumSolarMetallicity] autorelease];
}

+ (GLGFloatPair *) radiusRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarRadius andFloat:maximumSolarRadius] autorelease];
}

+ (GLGFloatPair *) massRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarMass andFloat:maximumSolarMass] autorelease];
}

+ (GLGFloatPair *) surfaceTemperatureRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarSurfaceTemperature andFloat:maximumSolarSurfaceTemperature] autorelease];
}

+ (GLGFloatPair *) rotationRateRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarRotationRate andFloat:maximumSolarRotationRate] autorelease];
}

+ (GLGFloatPair *) ageRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarAge andFloat:maximumSolarAge] autorelease];
}

+ (GLGFloatPair *) luminosityRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarLuminosity andFloat:maximumSolarLuminosity] autorelease];
}

+ (GLGFloatPair *) apparentMagnitudeRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarAppMagnitude andFloat:maximumSolarAppMagnitude] autorelease];
}

+ (GLGFloatPair *) absoluteMagnitudeRange {
    return [[[GLGFloatPair alloc] initWithFloat:minimumSolarAbsMagnitude andFloat:maximumSolarAbsMagnitude] autorelease];;
}

@end
