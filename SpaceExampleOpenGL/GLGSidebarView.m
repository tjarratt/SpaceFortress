//
//  GLGSidebarView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import "GLGSidebarView.h"

@implementation GLGSidebarView

- (id)initWithFrame:(NSRect)frame systems:(NSMutableArray *)systems andDelegate: (id) delegate {
    if (self = [super initWithFrame:frame]) {
        CGFloat padding = 5.0f;
        CGFloat heightOfGalaxyItem = 100.0f;
        subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];
        CGFloat heightOfScrollView = padding + (padding + heightOfGalaxyItem) * [systems count] + 60;
        CGFloat widthOfScrollView = frame.size.width;
        CGFloat __block height = heightOfScrollView - 44;
        
        [self setHasHorizontalScroller:NO];
        [self setHasVerticalScroller:YES];
        [self setBorderType:NSNoBorder];
        [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

        NSRect innerFrame = NSMakeRect(0, 0, widthOfScrollView, heightOfScrollView);
        innerView = [[NSView alloc] initWithFrame:innerFrame];
        [self setDocumentView: innerView];
        
        GLGLabel *framerateValue = [[GLGLabel alloc] initWithFrame:NSMakeRect(65, 0, 60, 20)];
        [framerateValue bind:@"value" toObject:delegate withKeyPath:@"framerate" options:nil];
        [innerView addSubview:framerateValue];
        [framerateValue release];
        subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];

        NSTextField *framerateLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 80, 20)];
        [framerateLabel setEditable:NO];
        [framerateLabel setStringValue:@"Framerate:"];
        [framerateLabel setBezeled:NO];
        [framerateLabel setSelectable:NO];
        [framerateLabel setBackgroundColor:[NSColor clearColor]];
        [innerView addSubview:framerateLabel];
        [framerateLabel release];
        
        [systems enumerateObjectsUsingBlock:^(GLGSolarSystem *system, NSUInteger index, BOOL *stop) {
            height -= padding + heightOfGalaxyItem;
            NSRect rect = NSMakeRect(0, height, frame.size.width, heightOfGalaxyItem);
            GLGSidebarGalaxyView *view = [[GLGSidebarGalaxyView alloc] initWithFrame:rect delegate: delegate andSystem:system];
            [innerView addSubview:view];
            [subViews addObject:view];
            [view release];
        }];
        
        [[self contentView] scrollToPoint:NSMakePoint(0, heightOfScrollView)];
    }
    
    return self;
}

- (void) scrollWheel:(NSEvent *)theEvent {
    [super scrollWheel:theEvent];
    [innerView setNeedsDisplay:YES];
}

- (void) didSelectObjectAtIndex:(NSInteger) index {
    [subViews enumerateObjectsUsingBlock:^(GLGSidebarGalaxyView *view, NSUInteger idx, BOOL *stop) {
        [view setSelected:(index == idx)];
        [view setNeedsDisplay:YES];
    }];
}

@end
