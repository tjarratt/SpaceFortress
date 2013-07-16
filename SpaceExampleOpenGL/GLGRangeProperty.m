//
//  RangeProperty.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/20/13.
//
//

#import "GLGRangeProperty.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation GLGRangeProperty

+(CGFloat) randomValueWithMinimum:(CGFloat)min maximum:(CGFloat)max {
    CGFloat scale = (double) arc4random() / ARC4RANDOM_MAX;
    return scale * (max - min) + min;
}

+(CGFloat) randomValueWithMinimum:(CGFloat)min maximum:(CGFloat)max scaling:(CGFloat) factor {
    return [self randomValueWithMinimum:min maximum:max] * factor;
}

@end
