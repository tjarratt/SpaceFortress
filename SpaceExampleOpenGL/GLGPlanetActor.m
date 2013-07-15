//
//  GLGPlanetActor.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import "GLGPlanetActor.h"

@implementation GLGPlanetActor

- (void) updateWithView:(GLGView *)view {

}

- (void) updateFramerate {

}

- (void) incrementFrameNumber {
    frameNumber += 1;
}

- (NSUInteger) frameNumber {
    return frameNumber;
}

- (void) didZoom:(CGFloat) amount {

}

- (void) didPanByVector:(CGPoint) vector {

}
@end
