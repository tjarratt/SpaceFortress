//
//  GLGSolarStar.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//
#import "GLGBody.h"
#import "GLGPlanetoid.h"
#import <Foundation/Foundation.h>
#import "GLGRangeProperty.h"

/*
facts:
  85% of all stars are red dwarfs
*/

@interface GLGSolarStar : GLGBody {
    CGFloat surfaceTemperature;
    NSUInteger rotationRateSeconds;
    NSString *name;
    
    // percentage of its mass not derived from H, HE
    // http://en.wikipedia.org/wiki/Metallicity
    CGFloat metallicity;
    CGFloat absoluteMagnitude;
    CGFloat apparentMagnitude;
    
    NSString *classification;
    NSString *luminosityClass;
    NSString *primaryClass;
}

@property CGFloat habitableZoneInnerRadius;
@property CGFloat habitableZoneOuterRadius;

- (id) sol;

// classification (O B A B G K M)
// http://en.wikipedia.org/wiki/Spectral_classification
- (NSString *) spectralClassification;
- (CGFloat) luminosity;
- (CGFloat) metallicity;
- (CGFloat) apparentMagnitude;
- (CGFloat) surfaceTemperature;
- (CGFloat) rotationRate;
- (CGFloat) radius;
- (NSString *) habitableZoneRange;

#pragma mark - class property ranges
+ (NSRange) metallicityRange;
+ (NSRange) radiusRange;
+ (NSRange) massRange;
+ (NSRange) surfaceTemperatureRange;
+ (NSRange) rotationRateRange;
+ (NSRange) ageRange;
+ (NSRange) luminosityRange;

@end
