//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "GLGOpenGLController.h"

@implementation GLGOpenGLController

@synthesize paused;

const CGFloat sidebarWidth = 200;

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
        CGFloat sceneWidth = rectWidth - sidebarWidth;
        CGFloat sceneHeight = rectHeight - 50;

        NSRect windowRect = NSMakeRect(0, 0, rectWidth, rectHeight);
        NSRect viewRect = NSMakeRect(0, 0, sceneWidth, sceneHeight);
        NSPoint point = NSMakePoint((width - rectWidth) / 2, (height - rectHeight) / 2);
        [window setFrame:windowRect display:YES];
        [window setFrameOrigin:point];

        expandedSceneRect = viewRect;
        collapsedSceneRect = NSMakeRect(viewRect.origin.x, viewRect.origin.y, viewRect.size.width + sidebarWidth - 10, viewRect.size.height);

        scene = [[GLGOpenGLView alloc] initWithFrame: viewRect];
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
        sidebar = [[GLGGalaxySidebar alloc] initWithFrame:sidebarFrame  andDelegate:actor];

        NSRect titleFrame = NSMakeRect(0, sceneHeight, sceneWidth, 50);
        titleView = [[NSView alloc] initWithFrame:titleFrame];
        NSRect innerFrame = NSMakeRect(5, 0, 600, 25);
        title = [[NSTextField alloc] initWithFrame:innerFrame];
        [title setEditable:NO];
        [title setBezeled:NO];
        [title setSelectable:NO];
        [title setBackgroundColor:[NSColor clearColor]];
        [title setStringValue:@"Choose a galaxy to colonize > "];
        [titleView addSubview:title];

        [[window contentView] addSubview:scene];
        [[window contentView] addSubview:sidebar];
        [[window contentView] addSubview:titleView];
        
        [window setMinSize:NSMakeSize(800, 600)];
        [window setAspectRatio:NSMakeSize(rectWidth, rectHeight)];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didSelectPlanet:) name:@"glg_did_select_planet" object:nil];
        [center addObserver:self selector:@selector(didResignPlanet) name:@"glg_did_resign_planet" object:nil];
        [center addObserver:self selector:@selector(didSelectSystem:) name:@"glg_did_select_system" object:nil];
        [center addObserver:self selector:@selector(didResignSystem) name:@"glg_did_resign_system" object:nil];
      }

    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - view actor NSNotificationCenter methods
- (void) didSelectPlanet:(NSNotification *) notification {
    NSRect buttonRect = NSMakeRect(605, 0, 80, 25);
    switchView = [[NSButton alloc] initWithFrame:buttonRect];
    [switchView setTitle:@"Embark!"];
    [switchView setTarget:self];
    [switchView setAction:@selector(switchToPlanetView)];
    [titleView addSubview:switchView];
}

- (void) didResignPlanet {
    if (switchView) {
        [switchView removeFromSuperview];
        [switchView release];
        switchView = nil;
    }
}

- (void) switchToPlanetView {
    GLGGalaxyPickerActor *actor = (GLGGalaxyPickerActor *) gameSceneActor;
    GLGPlanetoid *planet = [actor selectedPlanet];
    assert( planet != nil );

    [actor release];
    GLGPlanetActor *newActor = [[GLGPlanetActor alloc] initWithPlanet:planet delegate:self];

    [title removeFromSuperview];
    [titleView removeFromSuperview];
    title = nil;
    titleView = nil;
    
    NSRect oldSidebarFrame = [sidebar frame];
    [sidebar removeFromSuperview];
    [sidebar release];

    NSRect sidebarFrame = NSMakeRect(oldSidebarFrame.origin.x, oldSidebarFrame.origin.y, 0, oldSidebarFrame.size.height);

    CGFloat width = window.frame.size.width;
    CGFloat height = window.frame.size.height;
    [[scene animator] setFrame:NSMakeRect(0, 0, width, height)];

    sidebar = [[GLGPlanetSidebar alloc] initWithFrame:sidebarFrame andDelegate:newActor];
    [[window contentView] addSubview:sidebar];

    gameSceneActor = newActor;
}

- (void) didSelectSystem:(NSNotification *) notification {
    GLGSolarSystem *system = (GLGSolarSystem *)[notification object];
    NSString *newTitle = [NSString stringWithFormat:@"Choose a galaxy to colonize > Pick a planet in %@ >", [system name]];
    [title setStringValue:newTitle];
}

- (void) didResignSystem {
    [title setStringValue:@"Choose a galaxy to colonize >"];
}

- (GLGOpenGLView *) openGLView {
    return scene;
}

#pragma mark - NSWindow delegate methods
- (void) windowDidResize:(NSWindow *) _window {
    CGSize frameSize = window.frame.size;

    if (titleView) {
        expandedSceneRect = NSMakeRect(0, 0, frameSize.width - sidebarWidth, frameSize.height - 50);
        collapsedSceneRect = NSMakeRect(expandedSceneRect.origin.x, expandedSceneRect.origin.y, expandedSceneRect.size.width + sidebarWidth - 10, expandedSceneRect.size.height);
        [titleView setFrame:NSMakeRect(0, frameSize.height - 50, frameSize.width - sidebarWidth, 50)];
    }
    else {
        expandedSceneRect = NSMakeRect(0, 0, frameSize.width - sidebarWidth, frameSize.height);
        collapsedSceneRect = NSMakeRect(expandedSceneRect.origin.x, expandedSceneRect.origin.y, expandedSceneRect.size.width + sidebarWidth - 10, expandedSceneRect.size.height);

    }

    if ([sidebar collapsed]) {
        [scene setFrame:collapsedSceneRect];
    }
    else {
        [scene setFrame:expandedSceneRect];
    }

    NSRect newSidebarFrame = NSMakeRect(frameSize.width - sidebarWidth, 0, sidebarWidth, frameSize.height);
    [sidebar setFrame:newSidebarFrame];
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

- (void) GLGOpenGLView:(GLGOpenGLView *)view drawInRect:(NSRect)rect {
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

- (void) handleMouseDown:(NSPoint) point {
    [gameSceneActor handleMouseDown:point];
}

- (void) handleMouseUp {
    [gameSceneActor handleMouseUp];
}

#pragma mark - UI control methods
- (void) keyWasPressed:(NSEvent *)event {
    switch ([event keyCode]) {
        case 49:
            [self pause];
            break;
        case 11:
            [self expandOrCollapseSidebar];
            break;
    }
}

- (void) pause {
    [self setPaused:![self paused]];
}

- (void) expandOrCollapseSidebar {
    [NSAnimationContext beginGrouping];
    [sidebar expandOrCollapse];

    if ([sidebar collapsed]) {
        [[scene animator] setFrame:collapsedSceneRect];
    }
    else {
        [[scene animator] setFrame:expandedSceneRect];
    }

    [NSAnimationContext endGrouping];
}

@end
