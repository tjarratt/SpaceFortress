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
    GLGSolarSystem *_system;
    NSUInteger frameNumber;
    NSMutableArray *starField;
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
