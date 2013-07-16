//
//  GLGPlanetActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <tgmath.h>
#import <Foundation/Foundation.h>
#import "GLGOpenGLView.h"
#import "GLGActor.h"
#import "GLGRangeProperty.h"

@class GLGOpenGLView;

@interface GLGPlanetActor : NSObject <GLGActor> {
    NSUInteger frameNumber;
}
@end
