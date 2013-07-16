//
//  GLGPlanetActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <tgmath.h>
#import <Foundation/Foundation.h>
#import "GLGOpenGLView.h"
#import "GLGActor.h"
#import "GLGRangeProperty.h"
#import "GLGStructure.h"

@class GLGOpenGLView;

@interface GLGPlanetActor : NSObject <GLGActor> {
    NSUInteger frameNumber;
    GLGPlanetoid *planet;
    NSMutableArray *structures;
}

- (id) initWithPlanet:(GLGPlanetoid *) planet;
@end
