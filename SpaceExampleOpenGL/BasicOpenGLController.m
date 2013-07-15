//
//  BasicOpenGLController.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/17/13.
//
//

#import "BasicOpenGLController.h"

@implementation BasicOpenGLController

@synthesize paused, frameNumber, framerate;
@synthesize activeSystemIndex;

const NSUInteger solarSystemCapacity = 3;

#pragma Lifecycle methods
- (id) initWithWindow: (NSWindow *) theWindow {
    if (self = [super init]) {
        [NameProperty initialize];
        [self initializeSolarSystems];

        window = theWindow;
        [window setDelegate:self];
        
        zoomScale = [[GLGEasedValue alloc] initWithValue: 0.0f];
        [zoomScale setMinimum:-100.0f];
        [zoomScale setMaximum:100.0];
        origin = [[GLGEasedPoint alloc] initWithPoint:NSMakePoint(0, 0)];
        [origin setMinimum:NSMakePoint(-1200, -1200)];
        [origin setMaximum:NSMakePoint(1200, 1200)];
        
        frameNumber = 0;
        framerate = 0.0f;

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

        NSRect sidebarFrame = NSMakeRect(sceneWidth, 0, sidebarWidth, rectHeight);
        sidebar = [[GLGSidebarView alloc] initWithFrame:sidebarFrame systems:solarSystems andDelegate:self];
        activeSystemIndex = -1;

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

        [[window contentView] addSubview:scene];
        [[window contentView] addSubview:sidebar];
        [[window contentView] addSubview:titleView];
        
        [window setMinSize:NSMakeSize(rectWidth, rectHeight)];
        [window setAspectRatio:NSMakeSize(rectWidth, rectHeight)];

        // leave this till the very end so we don't skew our initial framerate
        // nothing is animated until we end this init and return to the runloop
        lastTimestamp = CFAbsoluteTimeGetCurrent();
      }

    return self;
}

- (void) initializeSolarSystems {
    selectedPlanet = nil;
    [solarSystems release];
    solarSystems = [[NSMutableArray alloc] initWithCapacity:solarSystemCapacity];
    for (int i = 0; i < solarSystemCapacity; ++i) {
        GLGSolarSystem *sys = [[GLGSolarSystem alloc] init];
        [solarSystems addObject:sys];
        [sys release];
    }
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

// 800 x 600 or 1280 x 800?
// 1280 pixels = 4.53556e12 -> one pixel = 3.543e9
// star is going to be ~6.9e8, orbits max out at 7e10
// but planets radius is only 35e6 on average!
// for the purposes of FUN, we'll need to scale up planet's size?
// suggest we scale up planets to 5-25 pixels
- (void) GLGOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    if (![self paused]) {
        [self setFrameNumber:(frameNumber + 1)];
    }

    CGFloat __block x, y, px, py, pxp, pyp;
    CGFloat zoomScaleFactor = powf(1.01, [zoomScale currentValue]);
    CGFloat metersToPixelsScale = 3.543e-11 * zoomScaleFactor;
    CGFloat scale = frameNumber * 2 * M_PI / 2.0e12;
    
    NSPoint currentOrigin = [origin currentValue];
    x = view.bounds.size.width / 2 + currentOrigin.x;
    y = view.bounds.size.height / 2 + currentOrigin.y;
    
    if (selectedPlanet != nil) {
        CGFloat planetX = -1 * selectedPlanet.apogeeMeters * metersToPixelsScale * cos(scale * selectedPlanet.rotationAroundSolarBodySeconds);
        CGFloat planetY = -1 * selectedPlanet.perogeeMeters * metersToPixelsScale * sin(scale * selectedPlanet.rotationAroundSolarBodySeconds);

        [origin setPoint:NSMakePoint(planetX, planetY)];
    }

    GLGSolarSystem *system = [self activeSystem];
    GLGSolarStar *star = [system star];
    NSColor *solarColor = [star color];
    glColor3f(solarColor.redComponent, solarColor.greenComponent, solarColor.blueComponent);
    CGFloat solarRadius = MAX(5, [star radius] * metersToPixelsScale * 100000);
    [view drawCircleWithRadius:solarRadius centerX:x centerY:y];
    
    glColor4f(0.1f, 0.65f, 0.1f, 0.1f);
    CGFloat innerRadius = star.habitableZoneInnerRadius * metersToPixelsScale;
    CGFloat outerRadius = star.habitableZoneOuterRadius * metersToPixelsScale;
    [view drawTorusAtPoint:NSMakePoint(x, y) innerRadius:innerRadius outerRadius:outerRadius];
    
    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        [view drawOrbitForPlanet:planet atScale:zoomScaleFactor atOrigin:[origin currentValue]];
    }];

    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        CGFloat radius = MAX([planet radius] * metersToPixelsScale * 5000, 1);

        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

        pxp = px * cos(planet.rotationAngleAroundStar) - py * sin(planet.rotationAngleAroundStar);
        pyp = px * sin(planet.rotationAngleAroundStar) + py * cos(planet.rotationAngleAroundStar);

        CGFloat translated_x = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat translated_y = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        pxp -= (translated_x - x);
        pyp -= (translated_y - y) ;
        
        glColor3f(planet.color.redComponent, planet.color.greenComponent, planet.color.blueComponent);
        [view drawCircleWithRadius:radius centerX:pxp centerY:pyp];
    }];
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

- (void) systemWasSelected:(GLGSolarSystem *) system {
    [zoomScale setCurrentValue:0 animate:NO];
    [origin setPoint:NSMakePoint(0, 0)];
    activeSystemIndex = [solarSystems indexOfObject:system];
    [sidebar didSelectObjectAtIndex:activeSystemIndex];
    selectedPlanet = nil;
}

- (void) startViewingPlanet:(GLGPlanetoid *) planet {
    assert( [self.activeSystem.planetoids indexOfObject:planet] >= 0 );

    [zoomScale setCurrentValue:20 animate:YES];
    CGFloat animationTime = 0.75; // less hardcoded please
    NSInteger framesToComplete = floor(animationTime * 30.0);
    NSInteger animationCompleteFrame = frameNumber + framesToComplete;

    CGFloat zoomScaleFactor = powf(1.01, 20);
    CGFloat metersToPixelsScale = 3.543e-11 * zoomScaleFactor;
    CGFloat scale = animationCompleteFrame * 2 * M_PI / 2.0e12;

    CGFloat planetX = -1 * planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
    CGFloat planetY = -1 * planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

    void (^completionHandler)(void) = ^(void) {
        selectedPlanet = planet;
    };

    [origin easeToPoint:NSMakePoint(planetX, planetY) withBlock:completionHandler];
}

- (void) stopViewingPlanet {
    [zoomScale setCurrentValue:0 animate:YES];
    [origin easeToPoint:NSMakePoint(0, 0)];
    
    selectedPlanet = nil;
}

- (void) didZoom:(CGFloat) amount {
    [zoomScale incrementBy:amount];
}

- (void) didPanByVector:(CGPoint) vector {
    if (selectedPlanet == nil) {
        [origin addVector:vector];
    }
}

#pragma mark - UI Observer binding methods
- (GLGSolarSystem *)activeSystem {
    if (activeSystemIndex < 0) { return nil; }

    return [solarSystems objectAtIndex:activeSystemIndex];
}

+ (NSSet *) keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    NSSet *affectedPaths = [[NSSet alloc] initWithArray:@[@"activeSystem"]];

    if ([affectedPaths containsObject:key]) {
        NSArray *otherPaths = @[@"activeSystemIndex"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:otherPaths];
    }

    [affectedPaths release];

    return keyPaths;
}

@end
