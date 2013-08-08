//
//  GLGActorBase.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGActor.h"

@interface GLGActorBase : NSObject {
    NSView *scene;
}

@property BOOL paused;

- (void) pause;
- (void) setScene:(NSView *) scene;
- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;
- (void) resizeWithWindow:(NSWindow *) window;
- (void) keyWasPressed:(unsigned short) key;
@end
