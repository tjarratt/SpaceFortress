//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "GLGOpenGLController.h"

@implementation GLGOpenGLController

#pragma Lifecycle methods
- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        [GLGNameProperty initialize];

        window = theWindow;
        [window setDelegate:self];
        
        CGFloat width = [[NSScreen mainScreen] frame].size.width;
        CGFloat height = [[NSScreen mainScreen] frame].size.height;
        CGFloat rectWidth = 1280;
        CGFloat rectHeight = 800;
        CGFloat sceneWidth = rectWidth;
        CGFloat sceneHeight = rectHeight;

        NSRect windowRect = NSMakeRect(0, 0, rectWidth, rectHeight);
        NSRect viewRect = NSMakeRect(0, 0, sceneWidth, sceneHeight);
        NSPoint point = NSMakePoint((width - rectWidth) / 2, (height - rectHeight) / 2);
        [window setFrame:windowRect display:YES];
        [window setFrameOrigin:point];

        scene = [[GLGOpenGLView alloc] initWithFrame: viewRect];
        [scene setWantsBestResolutionOpenGLSurface:YES];
        [scene setDelegate: self];
        [window makeFirstResponder:scene];
        [[window contentView] addSubview:scene];

        GLint swapInt = 1;
        [[scene openGLContext] makeCurrentContext];
        [[scene openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];

        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);

        [[window contentView] setWantsLayer:YES];
        GLGMainMenuActor *actor = [[GLGMainMenuActor alloc] initWithWindow:window andDelegate:self];
        [actor positionSubviewsRelativeToView:scene];
        [actor setScene:scene];
        gameSceneActor = (id)actor;

        [window setMinSize:NSMakeSize(800, 600)];
        [window setAspectRatio:NSMakeSize(rectWidth, rectHeight)];
      }

    return self;
}

#pragma mark - Scene Transition methods
- (void) switchToMainMenuView {
    id actor = (GLGGalaxyPickerActor *) gameSceneActor;
    [actor release];

    [scene setFrame: [[window contentView] frame]];

    GLGMainMenuActor *newActor = [[GLGMainMenuActor alloc] initWithWindow:window andDelegate:self];
    [newActor positionSubviewsRelativeToView:scene];
    [newActor setScene:scene];
    gameSceneActor = newActor;
}

- (void) switchToGalaxyView {
    id actor = (NSObject *) gameSceneActor;
    [actor release];

    NSRect frame = [[window contentView] frame];
    [scene setFrame:NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - sidebarWidth, frame.size.height - 25)];
    GLGGalaxyPickerActor *newActor = [[GLGGalaxyPickerActor alloc] initWithWindow:window];
    [newActor setDelegate:self];
    [newActor setScene:scene];

    gameSceneActor = newActor;
}

- (void) switchToPlanetView {
    GLGGalaxyPickerActor *actor = (GLGGalaxyPickerActor *) gameSceneActor;
    GLGPlanetoid *planet = [actor selectedPlanet];
    assert( planet != nil );

    [actor release];
    GLGPlanetActor *newActor = [[GLGPlanetActor alloc] initWithPlanet:planet delegate:self];
    [newActor setScene:scene];

    CGFloat width = window.frame.size.width;
    CGFloat height = window.frame.size.height;
    [[scene animator] setFrame:NSMakeRect(0, 0, width, height)];

    gameSceneActor = newActor;
}

- (GLGOpenGLView *) openGLView {
    return scene;
}

#pragma mark - NSWindow delegate methods
- (void) windowDidResize:(NSNotification *) notification {
    [gameSceneActor resizeWithWindow:[notification object]];
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
- (void) GLGOpenGLViewDidReshape:(NSOpenGLView *) view {
    const GLfloat width = [view bounds].size.width;
    const GLfloat height = [view bounds].size.height;

    NSParameterAssert(0 < height);

    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    glViewport(0, 0, width, height);
    glOrtho(0, width, 0, height, -1, 1);

    [[view openGLContext] update];
}

- (void) GLGOpenGLView:(GLGOpenGLView *) view drawInRect:(NSRect) rect {
    [gameSceneActor incrementFrameNumber];
    [gameSceneActor updateWithView:view];
}

- (void) didPanByVector:(CGPoint) vector {
    [gameSceneActor didPanByVector:vector];
}

- (void) didZoom:(CGFloat) amount {
    [gameSceneActor didZoom:amount];
}

- (void) handleMouseDown:(NSPoint) point {
    [gameSceneActor handleMouseDown:point];
}

- (void) handleMouseUp {
    [gameSceneActor handleMouseUp];
}

#pragma mark - UI control methods
- (void) keyWasPressed:(NSEvent *) event {
    [gameSceneActor keyWasPressed:[event keyCode]];
}

@end
