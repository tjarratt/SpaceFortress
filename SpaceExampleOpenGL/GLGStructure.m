//
//  GLGStructure.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/15/13.
//
//

#import "GLGStructure.h"

@implementation GLGStructure

@synthesize color, heightInStories, length;

- (id) initWithColor:(NSColor *)_color height:(NSInteger) _height length:(CGFloat) _length {
    if (self = [super init]) {
        self.color = _color;
        self.length = _length;
        self.heightInStories = _height;
    }

    return self;
}

@end
