//
//  GLGActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import <Foundation/Foundation.h>

@class GLGOpenGLView;

@protocol GLGActor
- (void) updateWithView:(GLGOpenGLView *)view;

- (void) incrementFrameNumber;
- (NSUInteger) frameNumber;
- (void) updateFramerate;

- (void) didPanByVector:(CGPoint) vector;
- (void) didZoom:(CGFloat) amount;

- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;
@end
