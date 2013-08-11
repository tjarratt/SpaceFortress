//
//  GLGPlanetoid.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import <Foundation/Foundation.h>
#import "constants.h"
#import "GLGBody.h"
#import "GLGSolarStar.h"
#import "GLGNameProperty.h"
#import "GLGRangeProperty.h"
#import "GLGPsychedeliaTrailer.h"

@class GLGSolarStar;

@interface GLGPlanetoid : GLGBody {
    GLGSolarStar *star;
    CGFloat surfaceTemperature;
    
    BOOL hasWater;
    BOOL hasAtmosphere;
    BOOL hasMagneticField;
 
    CGFloat averageDistanceFromStar;
    
    CGFloat metallicity;
    CGFloat averageAlbedo;
    CGFloat averageEmissivity;
    CGFloat escapeVelocity;

    NSMutableArray *trailers;

    int tickNumber;
}

@property CGFloat apogeeMeters;
@property CGFloat perogeeMeters;

@property CGFloat density;

@property CGFloat rotationAngleAroundStar;
@property CGFloat rotationAroundAxisSeconds;
@property CGFloat rotationAroundSolarBodySeconds;

- (id) initWithStar: (GLGSolarStar *) star;

// initialize as planets from "home solarsystem"
- (id) initAsMercury;
- (id) initAsVenus;
- (id) initAsEarth;
- (id) initAsMars;
- (id) initAsUranus;
- (id) initAsSaturn;
- (id) initAsNeptune;
- (id) initAsJupiter;


- (CGFloat) wattsSolarEnergyPerSquareMeter;
- (CGFloat) earthSimilarityIndex;

# pragma mark - psychedelia
- (NSMutableArray *) trailers;
- (void) tick;

@end
