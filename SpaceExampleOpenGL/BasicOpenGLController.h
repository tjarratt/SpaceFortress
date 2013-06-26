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
    GLGSolarSystem *system;
    NSWindow *window;
    GLGView *scene;
    
    NSView *sidebar;
    
    // framerate helpers
    NSUInteger last_frame;
    double last_timestamp;
}

@property CGFloat framerate;
@property NSUInteger frame_number;

- (id) initWithWindow: (NSWindow *) window;

- (void) update;
- (void) prepareOpenGL;
- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect;
- (void) BasicOpenGLViewDidReshape:(GLGView *)view;
- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;

@end
