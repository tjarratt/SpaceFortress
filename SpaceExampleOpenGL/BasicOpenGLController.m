//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "BasicOpenGLController.h"

@implementation BasicOpenGLController

@synthesize frame_number, framerate;
@synthesize paused;

- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        system = [[GLGSolarSystem alloc] init];
        [system describe_self];
        
        window = theWindow;
        frame_number = 0;
        framerate = 0.0f;
        
        int width = [[NSScreen mainScreen] frame].size.width;
        int height = [[NSScreen mainScreen] frame].size.height;
        int rect_width = 1280;
        int rect_height = 800;
        
        NSRect window_rect = NSMakeRect(0, 0, rect_width + 100, rect_height);
        NSRect view_rect = NSMakeRect(0, 0, rect_width, rect_height);
        NSPoint point = NSMakePoint((width - rect_width) / 2, (height - rect_height) / 2);
        [window setFrame:window_rect display:YES];
        [window setFrameOrigin:point];
        
        scene = [[GLGView alloc] initWithFrame: view_rect];
        [scene setWantsBestResolutionOpenGLSurface:YES];
        [scene setDelegate: self];
        [window makeFirstResponder:scene];

        [[scene openGLContext] makeCurrentContext];
        GLint swapInt = 1;
        [[scene openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
                
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        
        NSRect sidebar_frame = NSMakeRect(1280, 0, 100, 800);
        sidebar = [[GLGSidebarView alloc] initWithFrame:sidebar_frame system:system andDelegate:self];

        [[window contentView] addSubview:scene];
        [[window contentView] addSubview:sidebar];
        [window setMinSize:NSMakeSize(rect_width, rect_height)];
        
        // leave this till the very end so we don't skew our initial framerate
        // nothing is animated until we end this init and return to the runloop
        last_timestamp = CFAbsoluteTimeGetCurrent();
      }
    
    return self;
}

- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    NSLog(@"frame is resizing to %f, %f", frameSize.width, frameSize.height);
    NSRect new_frame = NSMakeRect(0, 0, frameSize.width - 200, frameSize.height);
    [scene setFrame:new_frame];
    return frameSize;
}

- (void) update_framerate {
    if (frame_number == last_frame) {
        return;
    }
    
    double current_time = CFAbsoluteTimeGetCurrent();
    double diff = current_time - last_timestamp;
    double rate = (frame_number - last_frame) / diff;
    [self setFramerate: round(rate * 100) / 100.0f];
    
    last_frame = frame_number;
    last_timestamp = current_time;
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
        [self setFrame_number:(frame_number + 1)];
    }
    
    CGFloat __block x, y, px, py;
    CGFloat __block meters_to_pixels_scale = 3.543e-11;
    CGFloat __block scale = frame_number * 2 * M_PI / (float) 600;
    
    GLGSolarStar *star = [system star];
    NSColor *solar_color = [star color];
    glColor3f(solar_color.redComponent, solar_color.greenComponent, solar_color.blueComponent);
    x = view.bounds.size.width / 2;
    y = view.bounds.size.height / 2;
    CGFloat solar_radius = MAX(5, [star radius] / 278400.0f);
    [view drawCircleWithRadius:solar_radius centerX:x centerY:y];
    
    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        glColor3f(0.85f, 0.35f, 0.35f);
        CGFloat radius = MAX([planet radius] * meters_to_pixels_scale, 5);

        px = x + planet.apogee_meters * meters_to_pixels_scale * cos(scale * 4.2 * planet.rotation_angle_around_star);
        py = y + planet.perogee_meters * meters_to_pixels_scale * sin(scale * 4.2 * planet.rotation_angle_around_star);
        [view drawCircleWithRadius:radius centerX:px centerY:py];
        [view drawOrbitForPlanet:planet atPointX:px pointY:py];
    }];
}

- (void) keyWasPressed:(NSEvent *)event {
    switch ([event keyCode]) {
        case 49:
            [self pause];
            break;
    }
}

- (void) reset_system {
    [system release];
    system = [[GLGSolarSystem alloc] init];

    [sidebar removeFromSuperview];
    [sidebar release];
    
    NSRect sidebar_frame = NSMakeRect(1280, 0, 100, 800);
    sidebar = [[GLGSidebarView alloc] initWithFrame:sidebar_frame system:system andDelegate:self];
    [[window contentView] addSubview: sidebar];
}

- (void) pause {
    [self setPaused:![self paused]];
}

@end
