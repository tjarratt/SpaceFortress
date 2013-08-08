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
@class GLGPlanetSidebar;

@interface GLGPlanetActor : GLGActorBase <GLGActor> {
    NSWindow *window;

    NSUInteger frameNumber;
    GLGPlanetoid *planet;
    NSMutableArray *structures;
    GLGOpenGLController *delegate;

    GLGPlanetSidebar *sidebar;

    NSPoint touchOrigin;
    NSPoint currentTouch;
    CGFloat rotation;

    NSRect expandedSceneRect;
    NSRect collapsedSceneRect;
}

- (id) initWithPlanet:(GLGPlanetoid *) planet delegate:(GLGOpenGLController *) _delegate;
- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;
@end
