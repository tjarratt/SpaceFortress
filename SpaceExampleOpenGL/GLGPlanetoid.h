//
//  GLGPlanetoid.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGSolarStar.h"
#import "NameProperty.h"
#import "RangeProperty.h"
#import <Foundation/Foundation.h>

@interface GLGPlanetoid : NSObject {
    CGFloat age;
    CGFloat mass;
    CGFloat radius;
    CGFloat surfaceTemperature;
    
    NSInteger rotationAroundAxisSeconds;
    NSInteger rotationAroundSolarBodySeconds;

    BOOL hasWater;
    BOOL hasAtmosphere;
    BOOL hasMagneticField;
 
    CGFloat averageDistanceFromStar;
    
    CGFloat metallicity;
    CGFloat averageAlbedo;
    CGFloat averageEmissivity;
}

@property CGFloat age;
@property CGFloat mass;
@property CGFloat radius;
@property (retain) NSString *name;

@property (retain) NSColor *color;

@property CGFloat apogeeMeters;
@property CGFloat perogeeMeters;

@property CGFloat rotationAngleAroundStar;

- (id) initWithStar: (GLGSolarStar *) star;
- (float) wattsSolarEnergyPerSquareMeter;
- (NSString *) friendlyMass;
- (NSString *) ageInBillionsOfYears;
- (void) describe;

@end
