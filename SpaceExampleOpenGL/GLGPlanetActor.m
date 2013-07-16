//
//  GLGPlanetActor.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import "GLGPlanetActor.h"

@implementation GLGPlanetActor

const CGFloat planetRadius = 500;

- (id) initWithPlanet:(GLGPlanetoid *) _planet {
    if (self = [super init]) {
        planet = _planet;
        structures = [[NSMutableArray alloc] init];

        CGFloat circumference = planetRadius * 2 * M_PI;
        CGFloat length = circumference / 10.0;
        __block CGFloat red, blue, green;
        __block NSColor *color;

        void (^randomizeColors)(void) = ^{
            red = [GLGRangeProperty randomValueWithMinimum:0 maximum:1];
            blue = [GLGRangeProperty randomValueWithMinimum:0 maximum:1];
            green = [GLGRangeProperty randomValueWithMinimum:0 maximum:1];
            color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:1.0];
        };

        for(int i = 0; i < 10; ++i) {
            randomizeColors();
            CGFloat r = (CGFloat) arc4random();
            CGFloat point = fmodf(r, circumference);
            GLGStructure *structure = [[GLGStructure alloc] initAtPoint:point withColor:color height:0 length:length];
            [structures addObject:structure]; // noep
            [structure release];
        }


        for (int i = 0; i < 10; ++i) {
            randomizeColors();
            CGFloat r = (CGFloat) arc4random();
            CGFloat point = fmodf(r, circumference);
            NSInteger height = floor([GLGRangeProperty randomValueWithMinimum:0 maximum:5]);
            GLGStructure *structure = [[GLGStructure alloc] initAtPoint:point withColor:color height:height length:length];
            [structures addObject:structure];
            [structure release];
        }

        for (int i = 0; i < 6; ++i) {
            randomizeColors();
            CGFloat r = (CGFloat) arc4random();
            CGFloat point = fmodf(r, circumference);
            CGFloat depth = i * -1.0;
            GLGStructure *structure = [[GLGStructure alloc] initAtPoint:point
                                                              withColor:color height:depth length:length];
            [structures addObject:structure];
            [structure release];
        }
    }

    return self;
}

- (void) updateWithView:(GLGOpenGLView *)view {
    CGFloat x = view.bounds.size.width / 2.0;
    CGFloat y = view.bounds.size.height * 0.15;
    NSPoint center = NSMakePoint(x, y);
    glColor3f(0.95f, 0.5f, 0.3f);
    [view drawCircleWithRadius:planetRadius centerX:x centerY:y];

    NSLog(@"enumerating over %lu structures", structures.count);
    [structures enumerateObjectsUsingBlock:^(GLGStructure *structure, NSUInteger index, BOOL *stop) {
        NSLog(@"drawing a structure");
        glColor3f(structure.color.redComponent, structure.color.greenComponent, structure.color.blueComponent);
        [view drawPolarRectAtPoint:structure.point withLength:structure.length atHeight:structure.heightInStories withCenter:center];
    }];
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
