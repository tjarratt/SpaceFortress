//
//  GLGEasedPoint.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/6/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGEasedValue.h"

typedef void (^VoidBlock)();

@interface GLGEasedPoint : NSObject {
    GLGEasedValue *x;
    GLGEasedValue *y;

    int pendingAnimations;
}

@property (copy) VoidBlock block;

- (id) initWithPoint:(NSPoint) point;

- (void) setPoint:(NSPoint) point;
- (void) addVector:(NSPoint) vector;
- (void) setMinimum:(NSPoint) minimum;
- (void) setMaximum:(NSPoint) maximum;

- (void) easeToPoint:(NSPoint) point;
- (void) easeToPoint:(NSPoint)point withBlock:(void *) block;
- (NSPoint) currentValue;

- (void) animationDidComplete;

@end
