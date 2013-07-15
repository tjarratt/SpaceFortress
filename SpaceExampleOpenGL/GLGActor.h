//
//  GLGActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <Foundation/Foundation.h>

@class GLGView;

@protocol GLGActor
- (void) updateWithView:(GLGView *)view;

- (void) incrementFrameNumber;
- (NSUInteger) frameNumber;
- (void) updateFramerate;

- (void) didPanByVector:(CGPoint) vector;
- (void) didZoom:(CGFloat) amount;
@end
