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
        collapsedRect = NSMakeRect(frameRect.origin.x + sidebarCollapsedWidth, frameRect.origin.y, frameRect.size.width, frameRect.size.height);

        [self setWantsLayer:YES];
        [[self layer] setBorderWidth:1.0];
        [[self layer] setCornerRadius:8.0];
        [[self layer] setMasksToBounds:YES];
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

- (void) setFrame:(NSRect) frame {
    expandedRect = frame;
    collapsedRect = NSMakeRect(frame.origin.x + sidebarCollapsedWidth, frame.origin.y, frame.size.width, frame.size.height);

    if (collapsed) {
        [super setFrame:collapsedRect];
    }
    else {
        [super setFrame:expandedRect];
    }
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
