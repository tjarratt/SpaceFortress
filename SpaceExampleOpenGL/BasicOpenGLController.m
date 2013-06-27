//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "BasicOpenGLController.h"

@implementation BasicOpenGLController

@synthesize frameNumber, framerate;
@synthesize paused;

- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        system = [[GLGSolarSystem alloc] init];
        
        window = theWindow;
        
        frameNumber = 0;
        framerate = 0.0f;
        
        int width = [[NSScreen mainScreen] frame].size.width;
        int height = [[NSScreen mainScreen] frame].size.height;
        int rectWidth = 1280;
        int rectHeight = 800;
        
        NSRect windowRect = NSMakeRect(0, 0, rectWidth + 100, rectHeight);
        NSRect viewRect = NSMakeRect(0, 0, rectWidth, rectHeight);
        NSPoint point = NSMakePoint((width - rectWidth - 100) / 2, (height - rectHeight) / 2);
        [window setFrame:windowRect display:YES];
        [window setFrameOrigin:point];
        
        scene = [[GLGView alloc] initWithFrame: viewRect];
        [scene setWantsBestResolutionOpenGLSurface:YES];
        [scene setDelegate: self];
        [window makeFirstResponder:scene];

        [[scene openGLContext] makeCurrentContext];
        GLint swapInt = 1;
        [[scene openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
                
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        
        NSRect sidebarFrame = NSMakeRect(1280, 0, 100, 800);
        sidebar = [[GLGSidebarView alloc] initWithFrame:sidebarFrame system:system andDelegate:self];

        [[window contentView] addSubview:scene];
        [[window contentView] addSubview:sidebar];
        [window setMinSize:NSMakeSize(rectWidth, rectHeight)];
        
        // leave this till the very end so we don't skew our initial framerate
        // nothing is animated until we end this init and return to the runloop
        lastTimestamp = CFAbsoluteTimeGetCurrent();
      }
    
    return self;
}

- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    NSLog(@"frame is resizing to %f, %f", frameSize.width, frameSize.height);
    NSRect newFrame = NSMakeRect(0, 0, frameSize.width - 200, frameSize.height);
    [scene setFrame:newFrame];
    return frameSize;
}

- (void) updateFramerate {
    if (frameNumber == lastFrame) {
        return;
    }
    
    double currentTime = CFAbsoluteTimeGetCurrent();
    double diff = currentTime - lastTimestamp;
    double rate = (frameNumber - lastFrame) / diff;
    [self setFramerate: round(rate * 100) / 100.0f];
    
    lastFrame = frameNumber;
    lastTimestamp = currentTime;
}

- (void) update {
    [scene update];
    [scene display];
}

- (void) prepareOpenGL {
    [self becomeFirstResponder];
    
    return;
}

#pragma mark - view delegate methods
- (void) BasicOpenGLViewDidReshape:(NSOpenGLView *)view {
    const GLfloat width = [view bounds].size.width;
    const GLfloat height = [view bounds].size.height;
    
    NSParameterAssert(0 < height);
    
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, width, 0, height, -1, 1);
    
    NSLog(@"resized to %f, %f", width, height);
}

// 800 x 600 or 1280 x 800?
// 1280 pixels = 4.53556e12 -> one pixel = 3.543e9
// star is going to be ~6.9e8, orbits max out at 7e10
// but planets radius is only 35e6 on average!
// for the purposes of FUN, we'll need to scale up planet's size?
// suggest we scale up planets to 5-25 pixels
- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    if (![self paused]) {
        [self setFrameNumber:(frameNumber + 1)];
    }
    
    CGFloat __block x, y, px, py, pxp, pyp;
    CGFloat __block metersToPixelsScale = 3.543e-11;
    CGFloat __block scale = frameNumber * 2 * M_PI / (float) 200;
    
    GLGSolarStar *star = [system star];
    NSColor *solarColor = [star color];
    glColor3f(solarColor.redComponent, solarColor.greenComponent, solarColor.blueComponent);
    x = view.bounds.size.width / 2;
    y = view.bounds.size.height / 2;
    CGFloat solarRadius = MAX(5, [star radius] / 278400.0f);
    [view drawCircleWithRadius:solarRadius centerX:x centerY:y];
    
    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        glColor3f(planet.color.redComponent, planet.color.greenComponent, planet.color.blueComponent);
        CGFloat radius = MAX([planet radius] * metersToPixelsScale, 5);

        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale);
        
        pxp = px * cos(planet.rotationAngleAroundStar) - py * sin(planet.rotationAngleAroundStar);
        pyp = px * sin(planet.rotationAngleAroundStar) + py * cos(planet.rotationAngleAroundStar);

        CGFloat translated_x = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat translated_y = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        pxp -= (translated_x - x);
        pyp -= (translated_y - y) ;
        
        [view drawCircleWithRadius:radius centerX:pxp centerY:pyp];
        [view drawOrbitForPlanet:planet atPointX:pxp pointY:pyp];
    }];
}

- (void) keyWasPressed:(NSEvent *)event {
    switch ([event keyCode]) {
        case 49:
            [self pause];
            break;
    }
}

- (void) resetSystem {
    [system release];
    system = [[GLGSolarSystem alloc] init];

    [sidebar removeFromSuperview];
    [sidebar release];
    
    NSRect sidebarFrame = NSMakeRect(1280, 0, 100, 800);
    sidebar = [[GLGSidebarView alloc] initWithFrame:sidebarFrame system:system andDelegate:self];
    [[window contentView] addSubview: sidebar];
}

- (void) pause {
    [self setPaused:![self paused]];
}

@end
