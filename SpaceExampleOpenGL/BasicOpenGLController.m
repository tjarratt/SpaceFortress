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
        window = theWindow;
        
        frame_number = 0;
        
        int width = [[NSScreen mainScreen] frame].size.width;
        int height = [[NSScreen mainScreen] frame].size.height;
        int rect_width = 800;
        int rect_height = 600;
        
        NSRect window_rect = NSMakeRect(0, 0, rect_width + 200, rect_height);
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
        
        NSRect sidebar_frame = NSMakeRect(800, 0, 200, 600);
        sidebar = [[NSView alloc] initWithFrame:sidebar_frame];

        label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 30)];
        [label setEditable:NO];
        [label bind:@"value" toObject:self withKeyPath:@"frame_number" options:nil];

        [sidebar addSubview:label];
        [[window contentView] addSubview:sidebar];
        
        [window setMinSize:NSMakeSize(1000, 600)];
  
        system = [[GLGSolarSystem alloc] init];
        [system describe_self];
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

- (void) BasicOpenGLViewDidReshape:(NSOpenGLView *)view {
    const GLfloat width = [view bounds].size.width;
    const GLfloat height = [view bounds].size.height;
    
    NSParameterAssert(0 < height);
    
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, width, 0, height, -1, 1);
    
    NSLog(@"resized to %f, %f", width, height);
}

- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    [self setFrame_number:(frame_number + 1)];
    
    glColor3f(1.0f, 0.85f, 0.35f);
    CGFloat x = view.bounds.size.width / 2;
    CGFloat y = view.bounds.size.height / 2;
    [view drawCircleWithRadius: 50 centerX: x centerY: y];
    
    glColor3f(0.5f, 0.85f, 0.35f);
    CGFloat scale = (frame_number) * 2 * M_PI / (float) 100;
    CGFloat planet_x = x + 300 * cos(scale);
    CGFloat planet_y = y + 200 * sin(scale);
    
    [view drawCircleWithRadius: 25 centerX:planet_x centerY:planet_y];
}


@end
