//
//  GLGPlanetActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <tgmath.h>
#import <Foundation/Foundation.h>
#import "GLGView.h"
#import "GLGActor.h"
#import "RangeProperty.h"

@interface GLGPlanetActor : NSObject <GLGActor> {
    NSUInteger frameNumber;
}
@end
