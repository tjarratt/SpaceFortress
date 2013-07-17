//
//  GLGSidebarView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import "GLGSidebarView.h"

@implementation GLGSidebarView
@synthesize collapsed;

- (id) init {
    if (self = [super init]) {
        collapsed = NO;
    }

    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (BOOL) isFlipped {
    return YES;
}

#pragma mark - ScrollView delegate methods
- (void) scrollWheel:(NSEvent *)theEvent {
    [super scrollWheel:theEvent];
    [innerView setNeedsDisplay:YES];
}

#pragma mark - expand / collapse

// xxx this doesn't work if you continuously expand / contract!
- (void) expandOrCollapse {
    collapsed = !collapsed;
    NSRect frame = [self frame];
    if (collapsed) {
        [[self animator] setFrame:NSMakeRect(frame.origin.x + 150, frame.origin.y, frame.size.width, frame.size.height)];
    }
    else {
        [[self animator] setFrame:NSMakeRect(frame.origin.x - 150, frame.origin.y, frame.size.width, frame.size.height)];
    }
}

@end
