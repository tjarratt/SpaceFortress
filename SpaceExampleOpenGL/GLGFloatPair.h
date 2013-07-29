//
//  GLGFloatPair.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/29/13.
//
//

#import <Foundation/Foundation.h>

@interface GLGFloatPair : NSObject {
    CGFloat first;
    CGFloat second;
}

- (id) initWithFloat:(CGFloat)one andFloat:(CGFloat)two;
- (CGFloat) first;
- (CGFloat) second;

@end
