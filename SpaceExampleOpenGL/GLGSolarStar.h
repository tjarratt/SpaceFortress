//
//  GLGSolarStar.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//
#import <Foundation/Foundation.h>

#import "GLGBody.h"
#import "GLGPlanetoid.h"
#import "GLGRangeProperty.h"
#import "GLGFloatPair.h"

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

- (id) initAsSol;

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
+ (GLGFloatPair *) metallicityRange;
+ (GLGFloatPair *) radiusRange;
+ (GLGFloatPair *) massRange;
+ (GLGFloatPair *) surfaceTemperatureRange;
+ (GLGFloatPair *) rotationRateRange;
+ (GLGFloatPair *) ageRange;
+ (GLGFloatPair *) luminosityRange;
+ (GLGFloatPair *) apparentMagnitudeRange;
+ (GLGFloatPair *) absoluteMagnitudeRange;

@end
