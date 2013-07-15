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

#import "GLGEasedPoint.h"
#import "GLGEasedValue.h"
#import "NameProperty.h"
#import "RangeProperty.h"
#import "GLGSolarSystem.h"

@class GLGSidebarView;

@interface BasicOpenGLController : NSViewController <GLGOpenGLViewDelegate, NSWindowDelegate> {
    NSWindow *window;
    GLGView *scene;
    GLGSidebarView *sidebar;
    NSView *titleView;
    NSTextField *title;
    
    GLGEasedValue *zoomScale;
    GLGEasedPoint *origin;
    NSMutableArray *solarSystems;
    
    // framerate helpers
    NSUInteger lastFrame;
    double lastTimestamp;
    
    GLGPlanetoid *selectedPlanet;
}

@property BOOL paused;
@property CGFloat framerate;
@property NSUInteger frameNumber;
@property NSInteger activeSystemIndex;

- (id) initWithWindow: (NSWindow *) window;

- (void) update;
- (void) prepareOpenGL;
- (void) GLGOpenGLView:(GLGView *)view drawInRect:(NSRect)rect;
- (void) GLGOpenGLViewDidReshape:(GLGView *)view;
- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;
- (void) keyWasPressed:(NSEvent *)event;
- (void) systemWasSelected:(GLGSolarSystem *) system;
- (GLGSolarSystem *) activeSystem;

- (void) startViewingPlanet:(GLGPlanetoid *) planet;
- (void) stopViewingPlanet;

- (void) didZoom:(CGFloat) amount;
- (void) didPanByVector:(CGPoint) vector;
@end
