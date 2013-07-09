//
//  GLGSidebarView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import "GLGSidebarView.h"

@implementation GLGSidebarView

const CGFloat heightOfGalaxyItem = 100.0f;

- (CGFloat) baseHeightForInnerView {
    CGFloat padding = 5.0;
    CGFloat heightOfScrollView = padding + (padding + heightOfGalaxyItem) * [systems count] + 60; // wtf 60?
    return heightOfScrollView;
}

- (id)initWithFrame:(NSRect)frame systems:(NSMutableArray *)_systems andDelegate: (id) delegate {
    if (self = [super initWithFrame:frame]) {
        systems = _systems;
        subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];

        CGFloat padding = 5.0f;
        CGFloat heightOfScrollView = padding + (padding + heightOfGalaxyItem) * [systems count] + 60;
        CGFloat widthOfScrollView = frame.size.width;
        CGFloat __block height = heightOfScrollView - 44;
        
        [self setHasHorizontalScroller:NO];
        [self setHasVerticalScroller:YES];
        [self setBorderType:NSNoBorder];
        [self setAutoresizingMask:NSViewHeightSizable];

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
    CGFloat __block difference = 0;
    [subViews enumerateObjectsUsingBlock:^(GLGSidebarGalaxyView *view, NSUInteger idx, BOOL *stop) {
        if (index == idx) {
            BOOL selected = ![view selected];
            [view setSelected:selected];

            if (selected) {
                difference += 5 + (25 + 5) * view.galaxy.planetoids.count;
            }
        }
        else {
            [view setSelected:NO];
        }
    }];

    [self shouldResizeBy:difference];
}

- (void) shouldResizeBy:(CGFloat) difference {
    NSRect frame = [innerView frame];
    CGFloat baseHeight = [self baseHeightForInnerView];
    NSRect newFrame = NSMakeRect(0, 0, frame.size.width, baseHeight + difference);

    [innerView setFrame:newFrame];
    [self resizeViews];
}

- (void) resizeViews {
    CGFloat padding = 5.0f;
    NSRect frame = [self frame];
    CGFloat heightOfScrollView = innerView.frame.size.height;

    CGFloat __block height = heightOfScrollView - 44;
    CGFloat __block pushDownHeight = 0;

    [subViews enumerateObjectsUsingBlock:^(GLGSidebarGalaxyView *view, NSUInteger index, BOOL *stop) {
        height -= padding + heightOfGalaxyItem;

        if ([view selected]) {
            pushDownHeight = 5 + (25 + 5) * view.galaxy.planetoids.count;
            height -= pushDownHeight;
            NSRect rect = NSMakeRect(0, height, frame.size.width, heightOfGalaxyItem + pushDownHeight);
            [view setFrame:rect];

        }
        else {
            NSRect rect = NSMakeRect(0, height, frame.size.width, heightOfGalaxyItem);
            NSRect pushedRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            [view setFrame:pushedRect];
        }

        [view setNeedsDisplay:YES];
    }];
}

@end
