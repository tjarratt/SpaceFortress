//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "BasicOpenGLController.h"

@implementation BasicOpenGLController

@synthesize paused;

#pragma Lifecycle methods
- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        [NameProperty initialize];

        window = theWindow;
        [window setDelegate:self];
        
        CGFloat width = [[NSScreen mainScreen] frame].size.width;
        CGFloat height = [[NSScreen mainScreen] frame].size.height;
        CGFloat rectWidth = 1280;
        CGFloat rectHeight = 800;
        CGFloat sidebarWidth = 150;
        CGFloat sceneWidth = rectWidth - sidebarWidth;
        CGFloat sceneHeight = rectHeight - 50;

        NSRect windowRect = NSMakeRect(0, 0, rectWidth, rectHeight);
        NSRect viewRect = NSMakeRect(0, 0, sceneWidth, sceneHeight);
        NSPoint point = NSMakePoint((width - rectWidth) / 2, (height - rectHeight) / 2);
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

        GLGGalaxyPickerActor *actor = [[GLGGalaxyPickerActor alloc] init];
        gameSceneActor = (id)actor;

        NSRect sidebarFrame = NSMakeRect(sceneWidth, 0, sidebarWidth, rectHeight);
        sidebar = [[GLGSidebarView alloc] initWithFrame:sidebarFrame  andDelegate:actor];

        NSRect titleFrame = NSMakeRect(0, sceneHeight, sceneWidth, 50);
        titleView = [[NSView alloc] initWithFrame:titleFrame];        
        NSRect innerFrame = NSMakeRect(5, 0, 200, 25);
        title = [[NSTextField alloc] initWithFrame:innerFrame];
        [title setEditable:NO];
        [title setBezeled:NO];
        [title setSelectable:NO];
        [title setBackgroundColor:[NSColor clearColor]];
        [title setStringValue:@"Choose a galaxy to colonize > "];
        [titleView addSubview:title];

        NSRect buttonRect = NSMakeRect(205, 0, 200, 25);
        NSButton *switchItUpButton = [[NSButton alloc] initWithFrame:buttonRect];
        [switchItUpButton setTitle:@"switch it up"];
        [switchItUpButton setTarget:self];
        [switchItUpButton setAction:@selector(switchItUp)];
        [titleView addSubview:switchItUpButton];

        [[window contentView] addSubview:scene];
        [[window contentView] addSubview:sidebar];
        [[window contentView] addSubview:titleView];
        
        [window setMinSize:NSMakeSize(rectWidth, rectHeight)];
        [window setAspectRatio:NSMakeSize(rectWidth, rectHeight)];
      }

    return self;
}

- (void) switchItUp {
    [gameSceneActor release];
    gameSceneActor = [[GLGPlanetActor alloc] init];

    [title removeFromSuperview];
    [sidebar removeFromSuperview];
    CGFloat width = window.frame.size.width;
    CGFloat height = window.frame.size.height;
    [[scene animator] setFrame:NSMakeRect(0, 0, width, height)];
}

#pragma mark - NSWindow delegate methods
- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    NSRect newFrame = NSMakeRect(0, 0, frameSize.width - 150, frameSize.height);
    [scene setFrame:newFrame];

    NSRect newSidebarFrame = NSMakeRect(frameSize.width - 150, 0, 150, frameSize.height);
    [sidebar setFrame:newSidebarFrame];

    return frameSize;
}

#pragma mark - openGL update methods
- (void) updateFramerate {
    [gameSceneActor updateFramerate];
}

- (void) update {
    [gameSceneActor updateWithView:scene];
    [scene display];
}

- (void) prepareOpenGL {
    [self becomeFirstResponder];

    return;
}

#pragma mark - view delegate methods
- (void) GLGOpenGLViewDidReshape:(NSOpenGLView *)view {
    const GLfloat width = [view bounds].size.width;
    const GLfloat height = [view bounds].size.height;

    NSParameterAssert(0 < height);

    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    glViewport(0, 0, width, height);
    glOrtho(0, width, 0, height, -1, 1);

    [[view openGLContext] update];
}

- (void) GLGOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    if (![self paused]) {
        [gameSceneActor incrementFrameNumber];
    }

    
    [gameSceneActor updateWithView:view];
}

- (void) didPanByVector:(CGPoint) vector {
    [gameSceneActor didPanByVector:vector];
}

- (void) didZoom:(CGFloat) amount {
    [gameSceneActor didZoom:amount];
}

#pragma mark - UI control methods
- (void) keyWasPressed:(NSEvent *)event {
    switch ([event keyCode]) {
        case 49:
            [self pause];
            break;
    }
}

- (void) pause {
    [self setPaused:![self paused]];
}

@end
