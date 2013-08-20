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
        start = [[NSButton alloc] init];
        [start setTitle:@"Start New Game"];
        [start setTarget:self];
        [start setAction:@selector(startNewGame)];

        quit = [[NSButton alloc] init];
        [quit setTitle:@"Quit"];
        [quit setTarget:self];
        [quit setAction:@selector(quit)];

        _system = [[GLGSolarSystem alloc] initAsSol];

        [self placeButtonsAtFrameCenter];
    }

    return self;
}

- (void) updateWithView:(GLGOpenGLView *) view {
    [super updateWithView:view];

    glColor3f(1, 1, 1);
    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glLineWidth(2.0);

    glBegin(GL_LINES);
    glVertex2d(95, 100);
    glVertex2d(100, 86);

    glEnd();

    glBegin(GL_LINES);
    glVertex2d(95, 100);
    glVertex2d(88, 87);

    glEnd();

    // draw particles
    glColor3f(0.99, 0.3, 0.2);
    NSPoint centerOfExhaust = NSMakePoint(98, 88);
    CGFloat max_size = 0.5;
    for(int i = 0; i < 10; ++i) {
        CGFloat x_random = (arc4random() / 0x10000000) * max_size;
        CGFloat y_random = (arc4random() / 0x10000000) * max_size * 2;

        [view drawCircleWithRadius:2 centerX:centerOfExhaust.x - x_random centerY:centerOfExhaust.y - y_random];
    }
}

- (void) resizeWithWindow:(NSWindow *) _window {
    NSRect frame = _window.frame;
    [scene setFrame: NSMakeRect(0, 0, frame.size.width, frame.size.height)];
    [self placeButtonsAtFrameCenter];
}

- (void) placeButtonsAtFrameCenter {
    NSRect frame = [[window contentView] frame];
    NSPoint center = NSMakePoint(frame.size.width / 2, frame.size.height / 2);
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 50;
    CGFloat padding = 15;
    CGFloat originX = center.x - buttonWidth / 2;
    CGFloat originY = center.y - (2 * buttonHeight + padding) / 2;

    NSRect quitRect = NSMakeRect(originX, originY, 200, 50);
    NSRect startRect = NSMakeRect(originX, originY + padding + buttonHeight, 200, 50);

    [start setFrame:startRect];
    [quit setFrame:quitRect];
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
