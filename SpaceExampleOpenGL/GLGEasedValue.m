//
//  GLGEasedValue.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/6/13.
//
//

#import "GLGEasedValue.h"

@implementation GLGEasedValue

- (id) initWithValue:(CGFloat) value {
    if (self = [super init]) {
        currentValue = value;
        
        animation = [[NSAnimation alloc] initWithDuration:0.75 animationCurve:NSAnimationEaseIn];
        [animation setDelegate:self];
        [animation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
        
        NSMutableArray *progressMarks = [[NSMutableArray alloc] initWithCapacity:100];
        for (CGFloat m = 0.0; m <= 1.0; m+= 0.01) {
            [progressMarks addObject:[NSNumber numberWithFloat:m]];
        }
        
        [animation setProgressMarks:progressMarks];
    }
    
    return self;
}

-(void) setMinimum:(CGFloat) min {
    minimum = min;
}

-(void) setMaximum:(CGFloat) max {
    maximum = max;
}

-(void) incrementBy:(CGFloat) value {
    [animation stopAnimation];
    currentValue += value;
}

-(CGFloat) currentValue {
    return currentValue;
}

-(void) setCurrentValue:(CGFloat) value animate:(BOOL) shouldAnimate{
    if (shouldAnimate) {
        startValue = currentValue;
        endValue = value;
        
        [animation stopAnimation];
        [animation startAnimation];
    }
    else {
        [animation stopAnimation];
        currentValue = MIN(value, maximum);
        currentValue = MAX(value, minimum);
    }
}

- (void) animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)progress {
    currentValue = startValue + progress * (endValue - startValue);
}

@end
