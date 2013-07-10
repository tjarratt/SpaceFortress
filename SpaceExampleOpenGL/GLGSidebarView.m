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
const CGFloat sidebarGalaxyPadding = 5.0f;
const CGFloat sidebarGalaxyHeight = 25.0f;

- (id)initWithFrame:(NSRect)frame systems:(NSMutableArray *)_systems andDelegate: (id) delegate {
    if (self = [super initWithFrame:frame]) {
        systems = _systems;
        subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];

        CGFloat padding = 5.0f;
        CGFloat heightOfScrollView = padding + (padding + heightOfGalaxyItem) * [systems count] + 60;
        CGFloat widthOfScrollView = frame.size.width;
        CGFloat __block height = 49;
        
        [self setHasHorizontalScroller:NO];
        [self setHasVerticalScroller:YES];
        [self setBorderType:NSNoBorder];
        [self setAutoresizingMask:NSViewHeightSizable];

        NSRect innerFrame = NSMakeRect(0, 0, widthOfScrollView, heightOfScrollView);
        innerView = [[GLGFlippedView alloc] initWithFrame:innerFrame];
        [self setDocumentView: innerView];

        framerateValue = [[GLGLabel alloc] initWithFrame:NSMakeRect(65, heightOfScrollView + 44, 60, 20)];
        [framerateValue bind:@"value" toObject:delegate withKeyPath:@"framerate" options:nil];
        [innerView addSubview:framerateValue];
        [framerateValue release];

        framerateLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, heightOfScrollView + 44, 80, 20)];
        [framerateLabel setEditable:NO];
        [framerateLabel setStringValue:@"Framerate:"];
        [framerateLabel setBezeled:NO];
        [framerateLabel setSelectable:NO];
        [framerateLabel setBackgroundColor:[NSColor clearColor]];
        [innerView addSubview:framerateLabel];
        [framerateLabel release];

        [systems enumerateObjectsUsingBlock:^(GLGSolarSystem *system, NSUInteger index, BOOL *stop) {
            NSRect rect = NSMakeRect(0, height, frame.size.width, heightOfGalaxyItem);
            GLGSidebarGalaxyView *view = [[GLGSidebarGalaxyView alloc] initWithFrame:rect delegate: delegate andSystem:system];
            [innerView addSubview:view];
            [subViews addObject:view];
            [view release];

            height += padding + heightOfGalaxyItem;
        }];
    }
    
    return self;
}

- (BOOL) isFlipped {
    return YES;
}

#pragma mark - ScrollView delegate methods
- (void) scrollWheel:(NSEvent *)theEvent {
    [super scrollWheel:theEvent];
    [innerView setNeedsDisplay:YES];
}

#pragma mark - methods to handle collapsing subviews
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

- (CGFloat) baseHeightForInnerView {
    CGFloat padding = 5.0;
    CGFloat heightOfScrollView = padding + (padding + heightOfGalaxyItem) * [systems count] + 60; // wtf 60?
    return heightOfScrollView;
}

- (void) shouldResizeBy:(CGFloat) difference {
    NSRect frame = [innerView frame];
    CGFloat baseHeight = [self baseHeightForInnerView];
    NSRect newFrame = NSMakeRect(0, 0, frame.size.width, baseHeight + difference);

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.2];

    [[innerView animator] setFrame:newFrame];
    [self resizeViews];

    [NSAnimationContext endGrouping];
}

- (void) resizeViews {
    NSRect frame = [self frame];
    CGFloat __block currentHeight = sidebarGalaxyPadding + 44;
    CGFloat __block pushDownHeight = 0;

    [subViews enumerateObjectsUsingBlock:^(GLGSidebarGalaxyView *view, NSUInteger index, BOOL *stop) {
        if ([view selected]) {
            pushDownHeight = sidebarGalaxyPadding + (sidebarGalaxyHeight + sidebarGalaxyPadding) * view.galaxy.planetoids.count;
            NSRect rect = NSMakeRect(0, currentHeight, frame.size.width, heightOfGalaxyItem + pushDownHeight);

            [view animateToFrame:rect];
            currentHeight += pushDownHeight;

        }
        else {
            NSRect rect = NSMakeRect(0, currentHeight, frame.size.width, heightOfGalaxyItem);
            NSRect pushedRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

            [view animateToFrame:pushedRect];
        }

        currentHeight += sidebarGalaxyPadding + heightOfGalaxyItem;
        [view setNeedsDisplay:YES];
    }];

    [[framerateValue animator] setFrame:NSMakeRect(65, currentHeight, 60, 20)];
    [[framerateLabel animator] setFrame:NSMakeRect(0, currentHeight, 80, 20)];
}

@end
