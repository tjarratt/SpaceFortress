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
    if (self = [self init]) {
        window = _window;
        delegate = _delegate;

        GLGEasedValue *zoom = [[GLGEasedValue alloc] initWithValue:-150];
        GLGEasedPoint *origin = [[GLGEasedPoint alloc] initWithPoint:NSMakePoint(0, -200)];
        [self setZoomScale:zoom];
        [self setOrigin:origin];
        [self setWantsPsychedelia:YES];

        [zoom release];
        [origin release];

        speedOfTime = [[GLGEasedValue alloc] initWithValue:10.0];
        
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

        _system = [[GLGSolarSystem alloc] initAsSol];
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

@end
