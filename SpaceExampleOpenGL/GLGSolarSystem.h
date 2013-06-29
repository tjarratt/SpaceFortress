//
//  GLGSolarSystem.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import <stdlib.h>
#import "GLGSolarStar.h"
#import "GLGPlanetoid.h"
#import <Foundation/Foundation.h>

@interface GLGSolarSystem : NSObject {
    NSMutableArray *planetoids;
    GLGSolarStar *star;
}

@property (readonly) NSMutableArray *planetoids;
@property (readonly) GLGSolarStar *star;

- (void) describeSelf;

@end
