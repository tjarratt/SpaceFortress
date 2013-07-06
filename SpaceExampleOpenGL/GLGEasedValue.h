//
//  GLGEasedValue.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/6/13.
//
//

#import <Foundation/Foundation.h>

@interface GLGEasedValue : NSObject <NSAnimationDelegate> {
    NSAnimation *animation;
    CGFloat endValue;
    CGFloat startValue;
    CGFloat currentValue;
    
    CGFloat minimum;
    CGFloat maximum;
}

-(id) initWithValue:(CGFloat) value;

-(CGFloat) currentValue;
-(void) setCurrentValue:(CGFloat) value animate:(BOOL) shouldAnimate;
-(void) incrementBy:(CGFloat) value;

-(void) setMinimum:(CGFloat) min;
-(void) setMaximum:(CGFloat) max;

-(void) animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)progress;
@end
