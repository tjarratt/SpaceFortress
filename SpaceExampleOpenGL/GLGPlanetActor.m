//
//  GLGPlanetActor.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import "GLGPlanetActor.h"

@implementation GLGPlanetActor

- (void) updateWithView:(GLGOpenGLView *)view {

    CGFloat planetRadius = 200;
    CGFloat x = view.bounds.size.width / 2.0;
    CGFloat y = view.bounds.size.height / 2.0;
    NSPoint center = NSMakePoint(x, y);
    glColor3f(0.95f, 0.5f, 0.3f);
    [view drawCircleWithRadius:planetRadius centerX:x centerY:y];

    CGFloat circumference = planetRadius * 2 * M_PI;
    CGFloat length = circumference / 10.0;
    __block CGFloat red, blue, green;

    void (^randomizeColors)(void) = ^{
        red = [GLGRangeProperty randomValueWithMinimum:0 maximum:1];
        blue = [GLGRangeProperty randomValueWithMinimum:0 maximum:1];
        green = [GLGRangeProperty randomValueWithMinimum:0 maximum:1];
        glColor3f(red, blue, green);
    };

    // simple test of drawing polar rects
    // draw several polar rects around the surface
    for(int i = 0; i < 10; ++i) {
        randomizeColors();
        CGFloat r = (CGFloat) arc4random();
        CGFloat point = fmodf(r, circumference);
        [view drawPolarRectAtPoint:point withLength:length atHeight:0 withCenter:center];
    }

    // draw several polar rects stacked above the surface
    for (int i = 0; i < 10; ++i) {
        randomizeColors();
        CGFloat r = (CGFloat) arc4random();
        CGFloat point = fmodf(r, circumference);
        NSInteger height = floor([GLGRangeProperty randomValueWithMinimum:0 maximum:5]);
        [view drawPolarRectAtPoint:point withLength:length atHeight:height  withCenter:center];
    }

    // draw several polar rects below the surface
    for (int i = 0; i < 6; ++i) {
        randomizeColors();
        CGFloat r = (CGFloat) arc4random();
        CGFloat point = fmodf(r, circumference);
        CGFloat depth = i * -1.0;
        [view drawPolarRectAtPoint:point withLength:length atHeight:depth withCenter:center];
    }
}

- (void) updateFramerate {
    
}

- (void) incrementFrameNumber {
    frameNumber += 1;
}

- (NSUInteger) frameNumber {
    return frameNumber;
}

- (void) didZoom:(CGFloat) amount {

}

- (void) didPanByVector:(CGPoint) vector {
    // actually, this should ROTATE
    // so maybe the correct interface here is mouseMovedToPoint:(CGPoint) point (?)
}
@end
