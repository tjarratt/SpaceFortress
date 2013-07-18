//
//  BasicOpenGLController.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import <OpenGL/OpenGL.h>
#import <Foundation/Foundation.h>

#import "GLGOpenGLView.h"
#import "GLGGalaxySidebar.h"
#import "GLGPlanetSidebar.h"

#import "GLGEasedPoint.h"
#import "GLGEasedValue.h"
#import "GLGNameProperty.h"
#import "GLGRangeProperty.h"
#import "GLGSolarSystem.h"

#import "GLGActor.h"
#import "GLGPlanetActor.h"
#import "GLGGalaxyPickerActor.h"

@class GLGSidebarView;

@interface GLGOpenGLController : NSViewController <GLGOpenGLViewDelegate, NSWindowDelegate> {
    NSWindow *window;
    GLGOpenGLView *scene;
    GLGSidebarView *sidebar;
    NSView *titleView;
    NSTextField *title;
    NSButton *switchView;

    id <GLGActor> gameSceneActor;

    NSRect expandedSceneRect;
    NSRect collapsedSceneRect;
}

@property BOOL paused;

- (id) initWithWindow: (NSWindow *) window;
- (void) update;
- (void) prepareOpenGL;
- (void) GLGOpenGLView:(GLGOpenGLView *)view drawInRect:(NSRect)rect;
- (void) GLGOpenGLViewDidReshape:(GLGOpenGLView *)view;
- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;
- (void) keyWasPressed:(NSEvent *)event;

- (GLGOpenGLView *) openGLView;

# pragma mark - actor delegate methods
- (void) didZoom:(CGFloat) amount;
- (void) didPanByVector:(CGPoint) vector;
- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;
@end

