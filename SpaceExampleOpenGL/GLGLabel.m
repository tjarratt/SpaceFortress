//
//  GLGLabel.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/3/13.
//
//

#import "GLGLabel.h"

@implementation GLGLabel

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setEditable:NO];
        [self setBezeled:NO];
        [self setSelectable:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    
    return self;
}

@end
