//
//  GLGPlanetoid.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "constants.h"
#import "GLGBody.h"
#import "GLGSolarStar.h"
#import "NameProperty.h"
#import "RangeProperty.h"
#import <Foundation/Foundation.h>

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
}

@property CGFloat apogeeMeters;
@property CGFloat perogeeMeters;

@property CGFloat density;

@property CGFloat rotationAngleAroundStar;
@property CGFloat rotationAroundAxisSeconds;
@property CGFloat rotationAroundSolarBodySeconds;

- (id) initWithStar: (GLGSolarStar *) star;
- (CGFloat) wattsSolarEnergyPerSquareMeter;
- (CGFloat) earthSimilarityIndex;
- (NSString *) friendlyMass;
- (NSString *) ageInBillionsOfYears;

@end
