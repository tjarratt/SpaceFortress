//
//  GLGSolarSystem.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGNameProperty.h"
#import "GLGSolarStar.h"
#import "GLGPlanetoid.h"
#import <Foundation/Foundation.h>

@interface GLGSolarSystem : NSObject {
    NSMutableArray *starField;
    NSMutableArray *planetoids;
    GLGSolarStar *star;
}

- (id) initAsSol;
- (NSMutableArray *) starField;

@property (retain) NSString *name;
@property (readonly) NSMutableArray *planetoids;
@property (readonly) GLGSolarStar *star;

@end
