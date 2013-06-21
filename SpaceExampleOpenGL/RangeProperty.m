//
//  RangeProperty.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/20/13.
//
//

#import "RangeProperty.h"

@implementation RangeProperty

+(CGFloat) randomValueWithMinimum:(CGFloat)min maximum:(CGFloat)max {
    return (random() / RAND_MAX) * (max - min) + min;
}

+(CGFloat) randomValueWithMinimum:(CGFloat)min maximum:(CGFloat)max scaling:(CGFloat) factor {
    return [self randomValueWithMinimum:min maximum:max] * factor;
}

@end
