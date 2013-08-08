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
#import "GLGOpenGLView.h"
#import "GLGGalaxySidebar.h"
#import "GLGSidebarGalaxyView.h"

@interface GLGGalaxyPickerActor : GLGActorBase <GLGActor, GLGSidebarDelegate> {
    NSWindow *window;
    GLGEasedValue *zoomScale;
    GLGEasedPoint *origin;

    NSMutableArray *solarSystems;

    NSUInteger lastFrame;
    double lastTimestamp;

    NSUInteger frameNumber;

    GLGGalaxySidebar *sidebar;
    NSView *titleView;
    NSTextField *title;
    NSButton *switchView;

    NSRect expandedSceneRect;
    NSRect collapsedSceneRect;
}

@property (retain) GLGPlanetoid *selectedPlanet;
@property NSInteger activeSystemIndex;
@property CGFloat framerate;

- (id) initWithWindow:(NSWindow *) _window;

- (void) systemWasSelected:(GLGSolarSystem *) system;
- (GLGSolarSystem *) activeSystem;

- (void) startViewingPlanet:(GLGPlanetoid *) planet;
- (void) stopViewingPlanet;

- (void) didZoom:(CGFloat) amount;
- (void) didPanByVector:(CGPoint) vector;

- (NSMutableArray *) solarSystems;
@end
