//
//  BasicOpenGLController.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import <OpenGL/OpenGL.h>
#import <Foundation/Foundation.h>

#import "GLGView.h"
#import "GLGSidebarView.h"

#import "RangeProperty.h"
#import "GLGSolarSystem.h"

@interface BasicOpenGLController : NSViewController <GLGOpenGLViewDelegate, NSWindowDelegate> {
    NSWindow *window;
    GLGView *scene;
    NSView *sidebar;
    
    NSUInteger activeSystemIndex;
    NSMutableArray *solarSystems;
    
    // framerate helpers
    NSUInteger lastFrame;
    double lastTimestamp;
}

@property CGFloat framerate;
@property NSUInteger frameNumber;
@property BOOL paused;

- (id) initWithWindow: (NSWindow *) window;

- (void) update;
- (void) prepareOpenGL;
- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect;
- (void) BasicOpenGLViewDidReshape:(GLGView *)view;
- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;
- (void) keyWasPressed:(NSEvent *)event;
- (GLGSolarSystem *) activeSystem;

@end
