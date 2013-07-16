//
//  GLGGalaxyPickerActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGActor.h"
#import "GLGEasedValue.h"
#import "GLGEasedPoint.h"
#import "GLGPlanetoid.h"
#import "GLGSolarSystem.h"
#import "GLGOpenGLView.h"
#import "GLGSidebarGalaxyView.h"

@interface GLGGalaxyPickerActor : NSObject <GLGActor, GLGSidebarDelegate> {
    GLGEasedValue *zoomScale;
    GLGEasedPoint *origin;

    NSMutableArray *solarSystems;
    GLGPlanetoid *selectedPlanet;

    // framerate helpers
    NSUInteger lastFrame;
    double lastTimestamp;

    NSUInteger frameNumber;
}

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
