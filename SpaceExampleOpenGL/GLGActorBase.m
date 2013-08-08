//
//  GLGActorBase.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import "GLGActorBase.h"

@implementation GLGActorBase

@synthesize paused;

- (void) setScene:(NSView *) _scene {
    scene = _scene;
}

- (void) handleMouseUp {

}

- (void) handleMouseDown:(NSPoint) point {

}

- (void) resizeWithWindow:(NSWindow *) window {
    
}

- (void) keyWasPressed:(unsigned short) key {
    
}

- (void) pause {
    [self setPaused:![self paused]];
}

@end
