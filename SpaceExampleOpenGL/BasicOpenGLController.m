//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "BasicOpenGLController.h"

@implementation BasicOpenGLController

@synthesize frame_number;

- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        system = [[GLGSolarSystem alloc] init];
        [system describe_self];

        window = theWindow;
        
        frame_number = 0;
        
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

        [[scene openGLContext] makeCurrentContext];
        GLint swapInt = 1;
        [[scene openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
                
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        
        [[window contentView] addSubview:scene];
        
        NSRect sidebar_frame = NSMakeRect(1280, 0, 100, 800);
        sidebar = [[NSView alloc] initWithFrame:sidebar_frame];

        label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [label setEditable:NO];
        [label bind:@"value" toObject:self withKeyPath:@"frame_number" options:nil];
        [sidebar addSubview:label];
        
        NSTextField *radius_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 100, 100, 30)];
        [radius_label setEditable:NO];
        [radius_label setStringValue:@"Percentage Solar Radius"];
        [sidebar addSubview:radius_label];
        
        NSTextField *radius_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 70, 100, 30)];
        [radius_value setEditable:NO];
        NSString *radius_string = [NSString stringWithFormat:@"%f", system.star.radius_comparison];
        [radius_value setStringValue: radius_string];
        [sidebar addSubview:radius_value];
        
        NSTextField *mass_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 200, 100, 30)];
        [mass_label setEditable:NO];
        [mass_label setStringValue:@"Percentage Solar Mass"];
        [sidebar addSubview:mass_label];
        
        NSString *mass_string = [NSString stringWithFormat:@"%f", system.star.mass_comparison];
        NSTextField *mass_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 170, 100, 30)];
        [mass_value setEditable:NO];
        [mass_value setStringValue:mass_string];
        [sidebar addSubview:mass_value];
        
        NSTextField *surface_temperature_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 300, 100, 30)];
        [surface_temperature_label setEditable:NO];
        [surface_temperature_label setStringValue:@"Percentage Solar Surface Temperature"];
        [sidebar addSubview:surface_temperature_label];
        
        NSString *surface_temperature_string = [NSString stringWithFormat:@"%f", system.star.surface_temperature_comparison];
        NSTextField *surface_temperature_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 270, 100, 30)];
        [surface_temperature_value setEditable:NO];
        [surface_temperature_value setStringValue:surface_temperature_string];
        [sidebar addSubview:surface_temperature_value];
        
        NSTextField *metallicity_label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 400, 100, 30)];
        [metallicity_label setEditable:NO];
        [metallicity_label setStringValue:@"Percentage Solar Metallicity"];
        [sidebar addSubview:metallicity_label];
        
        NSString *metallicity_string = [NSString stringWithFormat:@"%f", system.star.metallicity_comparison];
        NSTextField *metallicity_value = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 370, 100, 30)];
        [metallicity_value setEditable:NO];
        [metallicity_value setStringValue:metallicity_string];
        [sidebar addSubview:metallicity_value];

        [[window contentView] addSubview:sidebar];
        
        [window setMinSize:NSMakeSize(rect_width, rect_height)];
      }
    
    return self;
}

- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    NSLog(@"frame is resizing to %f, %f", frameSize.width, frameSize.height);
    NSRect new_frame = NSMakeRect(0, 0, frameSize.width - 200, frameSize.height);
    [scene setFrame:new_frame];
    return frameSize;
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

// 800 x 600
// 1280 pixels = 4.53556e12 -> one pixel = 3.543e9
// star is going to be ~6.9e8, orbits max out at 7e10
// but planets radius is only 35e6 on average!
// for the purposes of FUN, we'll need to scale up planet's size?
// suggest we scale up planets to 5-25 pixels
- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    [self setFrame_number:(frame_number + 1)];
    
    // demo with our solar system
    CGFloat scale = frame_number * 2 * M_PI / (float) 600;
    CGFloat meters_to_pixels_scale = 3.543e-9 / 2;
    CGFloat x, y, px, py;
    
    // draw the sun first
    glColor3f(1.0f, 0.85f, 0.35f);
    x = view.bounds.size.width / 2;
    y = view.bounds.size.height / 2;
    [view drawCircleWithRadius:30 centerX:x centerY:y];
    
    // mercury 0.4 AU
    glColor3f(0.85f, 0.35f, 0.35f);
    CGFloat au = 1.49e11;
    CGFloat mercury_max = 0.46 * au;
    CGFloat mercury_min = 0.3 * au;
    CGFloat mercury_radius = 2;
    px = x + mercury_max * cos(scale * 4.2) * meters_to_pixels_scale;
    py = y + mercury_min * sin(scale * 4.2) * meters_to_pixels_scale;
    [view drawCircleWithRadius:mercury_radius centerX:px centerY:py];
    
    // venus 0.7 AU
    CGFloat venus_min = 0.728 * au;
    CGFloat venus_max = 0.718 * au;
    CGFloat venus_radius = 5;
    glColor3f(0.85f, 0.85f, 0.85f);
    px = x + venus_max * cos(scale * 1.62) * meters_to_pixels_scale;
    py = y + venus_min * sin(scale * 1.62) * meters_to_pixels_scale;
    [view drawCircleWithRadius:venus_radius centerX:px centerY:py];
    
    // earth 1 AU
    CGFloat earth_max = 1.01 * au;
    CGFloat earth_min = 0.98 * au;
    CGFloat earth_radius = 6;
    glColor3f(0.1f, 0.35f, 0.85f);
    px = x + earth_max * cos(scale) * meters_to_pixels_scale;
    py = y + earth_min * sin(scale) * meters_to_pixels_scale;
    [view drawCircleWithRadius:earth_radius centerX:px centerY:py];
    
    // mars 1.5 AU
    CGFloat mars_max = 1.665 * au;
    CGFloat mars_min = 1.381 * au;
    CGFloat mars_radius = 3;
    glColor3f(0.9f, 0.5f, 0.1f);
    px = x + mars_max * cos(scale / 2) * meters_to_pixels_scale;
    py = y + mars_min * sin(scale / 2) * meters_to_pixels_scale;
    [view drawCircleWithRadius:mars_radius centerX:px centerY:py];
    
    return; // having trouble fitting more than 4 planets in currently
    
    // jupiter 5.2AU
    CGFloat jupiter_max = 5.45 * au;
    CGFloat jupiter_min = 4.9 * au;
    CGFloat jupiter_radius = 52.5;
    glColor3f(0.35f, 0.35f, 0.35f);
    px = x + 450 * cos(scale);
    py = y + 275 * sin(scale);
    [view drawCircleWithRadius:jupiter_radius centerX:px centerY:py];
    
    // saturn 9.5 AU
    CGFloat saturn_max = 10.11 * au;
    CGFloat saturn_min = 9.04 * au;
    CGFloat saturn_radius = 45;
    glColor3f(0.2f, 0.2f, 0.3f);
    px = x + 466 * cos(scale);
    py = y + 300 * sin(scale);
    [view drawCircleWithRadius:saturn_radius centerX:px centerY:py];
    
    // uranus 19.6 AU
    CGFloat uranus_max = 20.08 * au;
    CGFloat uranus_min = 18.375 * au;
    CGFloat uranus_radius = 20;
    glColor3f(0.9f, 0.1f, 0.7f);
    px = x + 488 * cos(scale);
    py = y + 322 * sin(scale);
    [view drawCircleWithRadius:uranus_radius centerX:px centerY:py];
    
    // neptune 30 AU
    CGFloat neptune_max = 30.44 * au;
    CGFloat neptune_min = 29.76 * au;
    CGFloat neptune_radius = 19.415;
    glColor3f(0.1f, 0.3f, 0.9f);
    px = x + 500 * cos(scale);
    py = y + 350 * sin(scale);
    [view drawCircleWithRadius:neptune_radius centerX:px centerY:py];
}


@end
