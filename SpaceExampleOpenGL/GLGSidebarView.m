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
        GLGLabel *framerateValue = [[GLGLabel alloc] initWithFrame:NSMakeRect(65, 0, 60, 20)];
        [framerateValue bind:@"value" toObject:delegate withKeyPath:@"framerate" options:nil];
        [self addSubview:framerateValue];
        [framerateValue release];
        subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];

        NSTextField *framerateLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 80, 20)];
        [framerateLabel setEditable:NO];
        [framerateLabel setStringValue:@"Framerate:"];
        [framerateLabel setBezeled:NO];
        [framerateLabel setSelectable:NO];
        [framerateLabel setBackgroundColor:[NSColor clearColor]];
        [self addSubview:framerateLabel];
        [framerateLabel release];
        
        subViews = [[NSMutableArray alloc] initWithCapacity:[systems count]];
        
        CGFloat padding = 5.0f;
        CGFloat heightOfGalaxyItem = 100.0f;
        CGFloat __block height = frame.size.height - 44;

        [systems enumerateObjectsUsingBlock:^(GLGSolarSystem *system, NSUInteger index, BOOL *stop) {
            height -= padding + heightOfGalaxyItem;
            NSRect rect = NSMakeRect(0, height, frame.size.width, heightOfGalaxyItem);
            GLGSidebarGalaxyView *view = [[GLGSidebarGalaxyView alloc] initWithFrame:rect delegate: delegate andSystem:system];
            [self addSubview:view];
            [subViews addObject:view];
            [view release];
        }];
    }
    
    return self;
}

- (void) didSelectObjectAtIndex:(NSInteger) index {
    [subViews enumerateObjectsUsingBlock:^(GLGSidebarGalaxyView *view, NSUInteger idx, BOOL *stop) {
        [view setSelected:(index == idx)];
        [view setNeedsDisplay:YES];
    }];
}

@end
