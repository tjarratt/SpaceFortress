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

        frameNumber = 0;
        framerate = 0.0f;

        int width = [[NSScreen mainScreen] frame].size.width;
        int height = [[NSScreen mainScreen] frame].size.height;
        int rectWidth = 1280;
        int rectHeight = 800;
        int sceneWidth = rectWidth - 100;

        NSRect windowRect = NSMakeRect(0, 0, rectWidth, rectHeight);
        NSRect viewRect = NSMakeRect(0, 0, sceneWidth, rectHeight);
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

        NSRect sidebarFrame = NSMakeRect(sceneWidth, 0, 100, rectHeight);
        sidebar = [[GLGSidebarView alloc] initWithFrame:sidebarFrame system:[self activeSystem] andDelegate:self];

        [[window contentView] addSubview:scene];
        [[window contentView] addSubview:sidebar];
        [window setMinSize:NSMakeSize(rectWidth, rectHeight)];
        [window setAspectRatio:NSMakeSize(rectWidth, rectHeight)];

        // leave this till the very end so we don't skew our initial framerate
        // nothing is animated until we end this init and return to the runloop
        lastTimestamp = CFAbsoluteTimeGetCurrent();
      }

    return self;
}

- (void) initializeSolarSystems {
    [solarSystems release];
    solarSystems = [[NSMutableArray alloc] initWithCapacity:solarSystemCapacity];
    for (int i = 0; i < solarSystemCapacity; ++i) {
        GLGSolarSystem *sys = [[GLGSolarSystem alloc] init];
        [solarSystems addObject:sys];
        [sys release];
    }
    [self setActiveSystemIndex:0];
}

#pragma mark - NSWindow delegate methods
- (NSSize) windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    NSRect newFrame = NSMakeRect(0, 0, frameSize.width - 100, frameSize.height);
    [scene setFrame:newFrame];

    NSRect newSidebarFrame = NSMakeRect(frameSize.width - 100, 0, 100, frameSize.height);
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
- (void) BasicOpenGLViewDidReshape:(NSOpenGLView *)view {
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
- (void) BasicOpenGLView:(GLGView *)view drawInRect:(NSRect)rect {
    if (![self paused]) {
        [self setFrameNumber:(frameNumber + 1)];
    }

    CGFloat __block x, y, px, py, pxp, pyp;
    CGFloat __block metersToPixelsScale = 3.543e-11;
    CGFloat __block scale = frameNumber * 2 * M_PI / (float) 2e12;
    GLGSolarSystem *system = [self activeSystem];

    GLGSolarStar *star = [system star];
    NSColor *solarColor = [star color];
    glColor3f(solarColor.redComponent, solarColor.greenComponent, solarColor.blueComponent);
    x = view.bounds.size.width / 2;
    y = view.bounds.size.height / 2;
    CGFloat solarRadius = MAX(5, [star radius] / 278400.0f);
    [view drawCircleWithRadius:solarRadius centerX:x centerY:y];
    
    // draw habitable zone
    glColor4f(0.1f, 0.65f, 0.1f, 0.1f);
    CGFloat innerRadius = star.habitableZoneInnerRadius * metersToPixelsScale;
    CGFloat outerRadius = star.habitableZoneOuterRadius * metersToPixelsScale;
    [view drawTorusAtPoint:NSMakePoint(x, y) innerRadius:innerRadius outerRadius:outerRadius];

    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        glColor3f(planet.color.redComponent, planet.color.greenComponent, planet.color.blueComponent);
        CGFloat radius = MAX([planet radius] * metersToPixelsScale, 5);

        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

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

#pragma mark - UI control methods
- (void) keyWasPressed:(NSEvent *)event {
    switch ([event keyCode]) {
        case 49:
            [self pause];
            break;
    }
}

- (void) nextSystem {
    if (self.activeSystemIndex == (solarSystemCapacity - 1)) {
        self.activeSystemIndex = 0;
    }
    else {
        ++self.activeSystemIndex;
    }
}

- (void) previousSystem {
    if (self.activeSystemIndex == 0) {
        self.activeSystemIndex = (solarSystemCapacity - 1);
    }
    else {
        --self.activeSystemIndex;
    }
}

- (void) pause {
    [self setPaused:![self paused]];
}

- (void) reset {
    [self initializeSolarSystems];
}

#pragma mark - UI Observer binding methods
- (GLGSolarSystem *)activeSystem {
    return [solarSystems objectAtIndex:activeSystemIndex];
}

- (NSString *) activeStarRadius {
    return [[[self activeSystem] star] radiusComparison];
}

- (NSString *) activeStarMass {
    return [[[self activeSystem] star] massComparison];
}

- (NSString *) activeStarTemperature {
    return [[[self activeSystem] star] surfaceTemperatureComparison];
}

- (NSString *) activeStarMetallicity {
    return [[[self activeSystem] star] metallicityComparison];
}

+ (NSSet *) keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    NSSet *affectedPaths = [[NSSet alloc] initWithArray:@[@"activeStarRadius", @"activeStarMass", @"activeStarTemperature", @"activeStarMetallicity"]];

    if ([affectedPaths containsObject:key]) {
        NSArray *otherPaths = @[@"activeSystemIndex"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:otherPaths];
    }

    [affectedPaths release];

    return keyPaths;
}

@end
