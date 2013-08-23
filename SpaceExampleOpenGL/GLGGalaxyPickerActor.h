//
//  GLGGalaxyPickerActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGActor.h"
#import "GLGActorBase.h"
#import "GLGEasedValue.h"
#import "GLGEasedPoint.h"
#import "GLGPlanetoid.h"
#import "GLGSolarSystem.h"
#import "GLGGalaxyActor.h"
#import "GLGOpenGLView.h"
#import "GLGGalaxySidebar.h"
#import "GLGSidebarGalaxyView.h"

@interface GLGGalaxyPickerActor : GLGGalaxyActor <GLGActor, GLGSidebarDelegate> {
    NSWindow *window;

    __weak id delegate;

    NSMutableArray *solarSystems;

    NSUInteger lastFrame;
    double lastTimestamp;

    GLGGalaxySidebar *sidebar;
    NSView *titleView;
    NSTextField *title;
    NSButton *switchView;

    NSRect expandedSceneRect;
    NSRect collapsedSceneRect;

    NSUInteger frameCount;
    NSButton *quitButton;
}

@property NSInteger activeSystemIndex;
@property CGFloat framerate;
@property BOOL wantsPsychedelia;

- (id) initWithWindow:(NSWindow *) _window;
- (void) setDelegate:(id) _delegate;

- (void) systemWasSelected:(GLGSolarSystem *) system;
- (GLGSolarSystem *) activeSystem;

- (void) startViewingPlanet:(GLGPlanetoid *) planet;
- (void) stopViewingPlanet;

- (void) didZoom:(CGFloat) amount;
- (void) didPanByVector:(CGPoint) vector;

- (NSMutableArray *) solarSystems;
@end
