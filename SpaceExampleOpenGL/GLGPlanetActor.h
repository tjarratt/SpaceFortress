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
#import "GLGActorBase.h"
#import "GLGRangeProperty.h"
#import "GLGStructure.h"
#import "GLGOpenGLController.h"

@class GLGOpenGLController;

@interface GLGPlanetActor : NSObject <GLGActor> {
    NSUInteger frameNumber;
    GLGPlanetoid *planet;
    NSMutableArray *structures;
    GLGOpenGLController *delegate;

    NSPoint touchOrigin;
    NSPoint currentTouch;
    CGFloat rotation;
}

- (id) initWithPlanet:(GLGPlanetoid *) planet delegate:(GLGOpenGLController *) _delegate;
- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;
@end
