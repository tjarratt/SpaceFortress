//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "BasicOpenGLController.h"

@implementation BasicOpenGLController

- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        window = theWindow;
        
        int width = [[NSScreen mainScreen] frame].size.width;
        int height = [[NSScreen mainScreen] frame].size.height;
        int rect_width = 800;
        int rect_height = 600;
        
        NSRect rect = NSMakeRect(0, 0, rect_width, rect_height);
        NSPoint point = NSMakePoint((width - rect_width) / 2, (height - rect_height) / 2);
        [window setFrame:rect display:YES];
        [window setFrameOrigin:point];
        
        scene = [[GLGView alloc] initWithFrame: rect];
        [scene setWantsBestResolutionOpenGLSurface:YES];
        [scene setDelegate: self];

        [[scene openGLContext] makeCurrentContext];
        GLint swapInt = 1;
        [[scene openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
                
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        
        [[window contentView] addSubview:scene];
        
        system = [[GLGSolarSystem alloc] init];
        [system describe_self];
    }
    
    return self;
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
    const GLfloat    width = [view bounds].size.width;
    const GLfloat    height = [view bounds].size.height;
    NSParameterAssert(0 < height);
    
    glViewport(0, 0, width, height);
}

- (void) BasicOpenGLView:(NSOpenGLView *)view drawInRect:(NSRect)rect {
    // NSLog(@"draw rect from controller delegate");
}


@end
