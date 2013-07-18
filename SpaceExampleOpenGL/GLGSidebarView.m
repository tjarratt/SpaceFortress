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

- (id) initWithFrame:(NSRect) frameRect {
    if (self = [super initWithFrame:frameRect]) {
        collapsed = NO;
        expandedRect = frameRect;
        collapsedRect = NSMakeRect(frameRect.origin.x + 150, frameRect.origin.y, frameRect.size.width, frameRect.size.height);
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

- (void) expandOrCollapse {
    collapsed = !collapsed;

    if (collapsed) {
        [[self animator] setFrame:collapsedRect];
    }
    else {
        [[self animator] setFrame:expandedRect];
    }
}

@end
