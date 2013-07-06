//
//  GLGEasedPoint.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/6/13.
//
//

#import <Foundation/Foundation.h>
#import "GLGEasedValue.h"

@interface GLGEasedPoint : NSObject {
    GLGEasedValue *x;
    GLGEasedValue *y;
}

- (id) initWithPoint:(NSPoint) point;

- (void) setPoint:(NSPoint) point;
- (void) addVector:(NSPoint) vector;
- (void) setMinimum:(NSPoint) minimum;
- (void) setMaximum:(NSPoint) maximum;

- (void) easeToPoint:(NSPoint) point;
- (NSPoint) currentValue;

@end
