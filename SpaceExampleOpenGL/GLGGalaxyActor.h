//
//  GLGGalaxyActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 8/10/13.
//
//

#import "GLGActorBase.h"
#import "GLGEasedPoint.h"
#import "GLGEasedValue.h"
#import "GLGOpenGLView.h"
#import "GLGSolarSystem.h"

@interface GLGGalaxyActor : GLGActorBase <GLGActor> {
    CGFloat frameNumber;
    GLGSolarSystem *_system;
    GLGEasedValue *speedOfTime;

    CGFloat planetSizeWeight;
}

@property (retain) GLGEasedPoint *origin;
@property (retain) GLGEasedValue *zoomScale;

@property BOOL wantsPsychedelia;
@property NSInteger activeSystemIndex;
@property (retain) GLGPlanetoid *selectedPlanet;

- (GLGSolarSystem *) activeSystem;
- (void) updateWithView:(GLGOpenGLView *) view;
- (NSUInteger) frameNumber;

@end
