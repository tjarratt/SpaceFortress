//
//  GLGEasedPoint.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/6/13.
//
//

#import "GLGEasedPoint.h"

@implementation GLGEasedPoint

- (id) initWithPoint:(NSPoint)point {
    if (self = [super init]) {
        x = [[GLGEasedValue alloc] initWithValue:point.x];
        y = [[GLGEasedValue alloc] initWithValue:point.y];
    }
    
    return self;
}

- (void) setMinimum:(NSPoint) minimum {
    [x setMinimum:minimum.x];
    [y setMinimum:minimum.y];
}

- (void) setMaximum:(NSPoint) maximum {
    [x setMaximum:maximum.x];
    [y setMaximum:maximum.y];
}

- (void) setPoint:(NSPoint)point {
    [x setCurrentValue:point.x animate:NO];
    [y setCurrentValue:point.y animate:NO];
}

- (void) addVector:(NSPoint)vector {
    [x setCurrentValue:x.currentValue + vector.x animate:NO];
    [y setCurrentValue:y.currentValue + vector.y animate:NO];
}

- (void) easeToPoint:(NSPoint)point {
    [x setCurrentValue:point.x animate:YES];
    [y setCurrentValue:point.y animate:YES];
}

- (NSPoint) currentValue {
    return NSMakePoint([x currentValue], [y currentValue]);
}
@end
