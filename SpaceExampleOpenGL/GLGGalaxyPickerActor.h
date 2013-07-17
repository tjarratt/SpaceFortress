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
#import "GLGSidebarGalaxyView.h"

@interface GLGGalaxyPickerActor : GLGActorBase <GLGActor, GLGSidebarDelegate> {
    GLGEasedValue *zoomScale;
    GLGEasedPoint *origin;

    NSMutableArray *solarSystems;

    NSUInteger lastFrame;
    double lastTimestamp;

    NSUInteger frameNumber;
}

@property (retain) GLGPlanetoid *selectedPlanet;
@property NSInteger activeSystemIndex;
@property CGFloat framerate;

- (void) systemWasSelected:(GLGSolarSystem *) system;
- (GLGSolarSystem *) activeSystem;

- (void) startViewingPlanet:(GLGPlanetoid *) planet;
- (void) stopViewingPlanet;

- (void) didZoom:(CGFloat) amount;
- (void) didPanByVector:(CGPoint) vector;

- (NSMutableArray *) solarSystems;
@end
