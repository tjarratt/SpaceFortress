//
//  GLGGalaxySidebar.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import "GLGGalaxySidebar.h"

@implementation GLGGalaxySidebar

const CGFloat heightOfGalaxyItem = 300.0f;
const CGFloat sidebarGalaxyPadding = 5.0f;
const CGFloat sidebarGalaxyHeight = 15.0f;

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectSidebarObject:) name:@"glg_sidebar_system_selected" object:nil];
    }
    
    return self;
}

- (void) setDelegate:(id) _delegate {
    NSRect frame = [self frame];
    delegate = _delegate;
    systems = [delegate solarSystems];
    subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];

    CGFloat padding = 5.0f;
    CGFloat heightOfScrollView = padding + (padding + heightOfGalaxyItem) * [systems count] + 60;
    CGFloat widthOfScrollView = frame.size.width - 5;
    CGFloat __block height = 49;

    [self setHasHorizontalScroller:NO];
    [self setHasVerticalScroller:YES];
    [self setBorderType:NSNoBorder];
    [self setAutoresizingMask:NSViewHeightSizable];

    NSRect innerFrame = NSMakeRect(5, 0, widthOfScrollView, heightOfScrollView);
    innerView = [[GLGFlippedView alloc] initWithFrame:innerFrame];
    [self setDocumentView: innerView];

    [systems enumerateObjectsUsingBlock:^(GLGSolarSystem *system, NSUInteger index, BOOL *stop) {
        NSRect rect = NSMakeRect(5, height, widthOfScrollView - 5, heightOfGalaxyItem);
        GLGSidebarGalaxyView *view = [[GLGSidebarGalaxyView alloc] initWithFrame:rect delegate: delegate andSystem:system];
        [innerView addSubview:view];
        [subViews addObject:view];
        [view release];

        height += padding + heightOfGalaxyItem;
    }];

    framerateValue = [[GLGLabel alloc] initWithFrame:NSMakeRect(80, height, 60, 20)];
    [framerateValue bind:@"value" toObject:delegate withKeyPath:@"framerate" options:nil];
    [innerView addSubview:framerateValue];
    [framerateValue release];

    framerateLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(15, height, 80, 20)];
    [framerateLabel setEditable:NO];
    [framerateLabel setStringValue:@"Framerate:"];
    [framerateLabel setBezeled:NO];
    [framerateLabel setSelectable:NO];
    [framerateLabel setBackgroundColor:[NSColor clearColor]];
    [innerView addSubview:framerateLabel];
    [framerateLabel release];
}

- (CGFloat) baseHeightForInnerView {
    CGFloat heightOfScrollView = sidebarGalaxyPadding + (sidebarGalaxyPadding + heightOfGalaxyItem) * [systems count] + 60;
    return heightOfScrollView;
}

- (void) didSelectSidebarObject:(NSNotification *) notification {
    NSInteger index = [delegate activeSystemIndex];

    CGFloat __block difference = 0;
    [subViews enumerateObjectsUsingBlock:^(GLGSidebarGalaxyView *view, NSUInteger idx, BOOL *stop) {
        if (index == idx) {
            BOOL selected = ![view selected];
            [view setSelected:selected];

            if (selected) {
                difference += sidebarGalaxyPadding + (sidebarGalaxyPadding + sidebarGalaxyHeight) * view.galaxy.planetoids.count;
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
            NSRect rect = NSMakeRect(5, currentHeight, frame.size.width - 10, heightOfGalaxyItem + pushDownHeight);

            [view animateToFrame:rect];
            currentHeight += pushDownHeight;

        }
        else {
            NSRect rect = NSMakeRect(5, currentHeight, frame.size.width - 5, heightOfGalaxyItem);
            NSRect pushedRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width - 5, rect.size.height);

            [view animateToFrame:pushedRect];
        }

        currentHeight += sidebarGalaxyPadding + heightOfGalaxyItem;
        [view setNeedsDisplay:YES];
    }];

    [[framerateValue animator] setFrame:NSMakeRect(80, currentHeight, 60, 20)];
    [[framerateLabel animator] setFrame:NSMakeRect(15, currentHeight, 80, 20)];
}

@end
