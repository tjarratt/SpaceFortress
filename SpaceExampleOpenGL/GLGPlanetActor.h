//
//  GLGPlanetActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import "GLGActor.h"
#import <Foundation/Foundation.h>

@class GLGView;

@interface GLGPlanetActor : NSObject <GLGActor> {
    NSUInteger frameNumber;
}
@end
