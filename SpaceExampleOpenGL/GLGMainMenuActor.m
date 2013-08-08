//
//  GLGMainMenuActor.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 8/7/13.
//
//

#import "GLGMainMenuActor.h"

@implementation GLGMainMenuActor

- (id) initWithWindow:(NSWindow *) _window andDelegate:(id) _delegate {
    if (self = [super init]) {
        window = _window;
        delegate = _delegate;

        NSRect frame = [[window contentView] frame];
        NSPoint center = NSMakePoint(frame.size.width / 2, frame.size.height / 2);
        CGFloat buttonWidth = 200;
        CGFloat buttonHeight = 50;
        CGFloat padding = 15;
        CGFloat originX = center.x - buttonWidth / 2;
        CGFloat originY = center.y - (2 * buttonHeight + padding) / 2;

        NSRect quitRect = NSMakeRect(originX, originY, 200, 50);
        NSRect startRect = NSMakeRect(originX, originY + padding + buttonHeight, 200, 50);
        start = [[NSButton alloc] initWithFrame:startRect];
        [start setTitle:@"Start New Game"];
        [start setTarget:self];
        [start setAction:@selector(startNewGame)];

        quit = [[NSButton alloc] initWithFrame:quitRect];
        [quit setTitle:@"Quit"];
        [quit setTarget:self];
        [quit setAction:@selector(quit)];
    }

    return self;
}

- (void) positionSubviewsRelativeToView:(NSView *) view {
    NSView *superview = [window contentView];
    [superview addSubview:start positioned:NSWindowAbove relativeTo:view];
    [superview addSubview:quit positioned:NSWindowAbove relativeTo:view];
}

- (void) dealloc {
    [start removeFromSuperview];
    [quit removeFromSuperview];
    [super dealloc];
}

#pragma mark - Main Menu actions
- (void) startNewGame {
    [delegate switchToGalaxyView];
}

- (void) quit {
    [window close];
}

#pragma mark - actor protocol view methods
- (void) updateWithView:(GLGOpenGLView *) view {
    // draw a starfield
}

#pragma mark - actor protocol framerate methods
- (NSUInteger) frameNumber {
    return 0;
}

- (void) updateFramerate {

}

- (void) incrementFrameNumber {

}

#pragma mark - actor protocol field of view methods
- (void) didPanByVector:(CGPoint) vector {

}

- (void) didZoom:(CGFloat) amount {

}

#pragma mark - mouse protocol methods
- (void) handleMouseDown:(NSPoint) point {

}

- (void) handleMouseUp {
    
}

@end
