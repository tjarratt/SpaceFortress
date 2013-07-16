//
//  RangeProperty.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/20/13.
//
//

#import <Foundation/Foundation.h>

@interface GLGRangeProperty : NSObject

+ (CGFloat) randomValueWithMinimum: (CGFloat)min maximum: (CGFloat)max;
+ (CGFloat) randomValueWithMinimum: (CGFloat)min maximum:(CGFloat)max scaling:(CGFloat) factor;
@end
