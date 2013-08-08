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

- (id) initWithWindow:(NSWindow *) _window andDelegate:(GLGOpenGLController *)_delegate {
    if (self = [super init]) {
       window = _window;
       delegate = _delegate;
    }

    return self;
}

- (void) setPlanet:(GLGPlanetoid *) _planet {

}

- (id) initWithPlanet:(GLGPlanetoid *) _planet delegate:(GLGOpenGLController *)_delegate {
    if (self = [super init]) {
        rotation = 0.0f;
        planet = _planet;
        delegate = _delegate;
        structures = [[NSMutableArray alloc] init];

        // TODO: make this dynamic
        CGFloat rectWidth = 1280;
        CGFloat rectHeight = 800;
        CGFloat sceneWidth = rectWidth - sidebarWidth;
        NSRect sidebarFrame = NSMakeRect(sceneWidth, 0, sidebarWidth, rectHeight);

        sidebar = [[GLGPlanetSidebar alloc] initWithFrame:sidebarFrame andDelegate:self];
        [[window contentView] addSubview:sidebar];

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

- (void) resizeWithWindow:(NSWindow *) _window {
    CGSize frameSize = _window.frame.size;
    
    expandedSceneRect = NSMakeRect(0, 0, frameSize.width - sidebarWidth, frameSize.height);
    collapsedSceneRect = NSMakeRect(expandedSceneRect.origin.x, expandedSceneRect.origin.y, expandedSceneRect.size.width + sidebarWidth - 10, expandedSceneRect.size.height);

    if ([sidebar collapsed]) {
        [scene setFrame:collapsedSceneRect];
    }
    else {
        [scene setFrame:expandedSceneRect];
    }

    NSRect newSidebarFrame = NSMakeRect(frameSize.width - sidebarWidth, 0, sidebarWidth, frameSize.height);
    [sidebar setFrame:newSidebarFrame];
}

- (void) updateWithView:(GLGOpenGLView *)view {
    CGFloat x = view.bounds.size.width / 2.0;
    CGFloat y = view.bounds.size.height * 0.15;
    NSPoint center = NSMakePoint(x, y);
    NSColor *color = [planet color];
    glColor3f(color.redComponent, color.greenComponent, color.blueComponent);

    [view setRotation: rotation];
    [view drawCircleWithRadius:planetRadius centerX:x centerY:y];

    [structures enumerateObjectsUsingBlock:^(GLGStructure *structure, NSUInteger index, BOOL *stop) {
        glColor3f(structure.color.redComponent, structure.color.greenComponent, structure.color.blueComponent);
        [view drawPolarRectAtPoint:structure.point withLength:structure.length atHeight:structure.heightInStories withCenter:center];
    }];

    [view setRotation: 0];
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
    assert( touchOrigin.x >= 0 && touchOrigin.y >= 0 );
    currentTouch = NSMakePoint(currentTouch.x + vector.x, currentTouch.y + vector.y);

    NSRect frame = [[delegate openGLView] frame];
    NSPoint center = NSMakePoint(frame.size.width / 2, 0);
    NSPoint vectorFromCenter = NSMakePoint(fabsf(touchOrigin.x - center.x), fabsf(touchOrigin.y - center.y));
    NSPoint touchFromCenter = NSMakePoint(fabsf(currentTouch.x - center.x), fabsf(currentTouch.y - center.y));

    CGFloat theta = atan2f(vectorFromCenter.x, vectorFromCenter.y);
    CGFloat phi = atan2f(touchFromCenter.x, touchFromCenter.y);

    rotation += (theta - phi) * 0.15;
}

- (void) handleMouseUp {
    touchOrigin = NSMakePoint(-1, -1);
    currentTouch = NSMakePoint(-1, -1);
}

- (void) handleMouseDown:(NSPoint) atPoint {
    touchOrigin = atPoint;
    currentTouch = atPoint;
}

@end
