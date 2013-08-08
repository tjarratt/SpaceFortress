//
//  GLGMainMenuActor.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 8/7/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGActor.h"
#import "GLGActorBase.h"

@interface GLGMainMenuActor : GLGActorBase <GLGActor> {
    __weak id delegate;
    __weak NSWindow *window;

    NSButton *start;
    NSButton *quit;
}

- (id) initWithWindow:(NSWindow *) window andDelegate:(id) _delegate;
- (void) positionSubviewsRelativeToView:(NSView *) view;

@end
