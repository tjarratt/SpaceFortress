//
//  GLGPlanetoid.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGSolarStar.h"
#import "RangeProperty.h"
#import <Foundation/Foundation.h>

@interface GLGPlanetoid : NSObject {
    CGFloat age;
    CGFloat mass;
    CGFloat radius;
    CGFloat surface_temperature;
    
    NSInteger rotation_around_axis_seconds;
    NSInteger rotation_around_solar_body_seconds;

    BOOL has_water;
    BOOL has_atmosphere;
    BOOL has_magnetic_field;
 
    CGFloat rotation_angle_around_star;
    CGFloat average_distance_from_star;
    CGFloat perogee_meters;
    CGFloat apogee_meters;
    
    CGFloat metallicity;
    CGFloat average_albedo;
    CGFloat average_emissivity;
}

- (id) initWithStar: (GLGSolarStar *) star;
- (float) wattsSolarEnergyPerSquareMeter;
- (NSString *) friendlyMass;
- (NSString *) ageInBillionsOfYears;
- (void) describe;

@end
