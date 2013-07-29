//
//  GLGFloatPair.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/29/13.
//
//

#import "GLGFloatPair.h"

@implementation GLGFloatPair

- (id) initWithFloat:(CGFloat)one andFloat:(CGFloat)two {
    if (self = [super init]) {
        first = one;
        second = two;
    }

    return self;
}

- (CGFloat) first {
    return first;
}

- (CGFloat) second {
    return second;
}

@end
