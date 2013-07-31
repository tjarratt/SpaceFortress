//
//  GLGGalaxyPickerActor.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/14/13.
//
//

#import "GLGGalaxyPickerActor.h"

@implementation GLGGalaxyPickerActor

@synthesize framerate;
@synthesize selectedPlanet;
@synthesize activeSystemIndex;

const NSUInteger solarSystemCapacity = 3;

- (id) initWithWindow:(NSWindow *) _window {
    if (self = [super init]) {
        window = _window;
        zoomScale = [[GLGEasedValue alloc] initWithValue: -500.0f];
        [zoomScale setMinimum:-100000.0f];
        [zoomScale setMaximum:100000.0];
        origin = [[GLGEasedPoint alloc] initWithPoint:NSMakePoint(0, 0)];
        [origin setMinimum:NSMakePoint(-1200, -1200)];
        [origin setMaximum:NSMakePoint(1200, 1200)];

        frameNumber = 0;
        framerate = 0.0f;

        activeSystemIndex = -1;
        [self initializeSolarSystems];

        CGFloat rectWidth = 1280;
        CGFloat rectHeight = 800;
        CGFloat sceneWidth = rectWidth - sidebarWidth;
        CGFloat sceneHeight = rectHeight - 50;

        NSRect sidebarFrame = NSMakeRect(sceneWidth, 0, sidebarWidth, rectHeight);
        sidebar = [[GLGGalaxySidebar alloc] initWithFrame:sidebarFrame];
        [sidebar setDelegate:self];

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
        
        [[window contentView] addSubview:sidebar];
        [[window contentView] addSubview:titleView];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didSelectPlanet:) name:@"glg_did_select_planet" object:nil];
        [center addObserver:self selector:@selector(didResignPlanet) name:@"glg_did_resign_planet" object:nil];
        [center addObserver:self selector:@selector(didSelectSystem:) name:@"glg_did_select_system" object:nil];
        [center addObserver:self selector:@selector(didResignSystem) name:@"glg_did_resign_system" object:nil];

        lastTimestamp = CFAbsoluteTimeGetCurrent();
    }

    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObject:self];

    [title removeFromSuperview];
    [titleView removeFromSuperview];
    title = nil;
    titleView = nil;

//    NSRect oldSidebarFrame = [sidebar frame];
//    NSRect sidebarFrame = NSMakeRect(oldSidebarFrame.origin.x, oldSidebarFrame.origin.y, 0, oldSidebarFrame.size.height);

    [sidebar removeFromSuperview];
    [sidebar release];

    [super dealloc];
}

- (void) resizeWithWindow:(NSWindow *) _window {
    CGSize frameSize = _window.frame.size;

    expandedSceneRect = NSMakeRect(0, 0, frameSize.width - sidebarWidth, frameSize.height - 50);
    collapsedSceneRect = NSMakeRect(expandedSceneRect.origin.x, expandedSceneRect.origin.y, expandedSceneRect.size.width + sidebarWidth - 10, expandedSceneRect.size.height);
    [titleView setFrame:NSMakeRect(0, frameSize.height - 50, frameSize.width - sidebarWidth, 50)];

    if ([sidebar collapsed]) {
        [scene setFrame:collapsedSceneRect];
    }
    else {
        [scene setFrame:expandedSceneRect];
    }

    NSRect newSidebarFrame = NSMakeRect(frameSize.width - sidebarWidth, 0, sidebarWidth, frameSize.height);
    [sidebar setFrame:newSidebarFrame];
}

# pragma mark - frameRate methods
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

- (void) incrementFrameNumber {
    if ([self paused]) { return; }
    
    frameNumber += 1;
}

- (NSUInteger) frameNumber {
    return frameNumber;
}

# pragma mark - view methods
- (void) updateWithView:(GLGOpenGLView *)view {
    CGFloat __block x, y, px, py, pxp, pyp;
    CGFloat zoomScaleFactor = powf(1.01, [zoomScale currentValue]);
    CGFloat metersToPixelsScale = 3.543e-9 * zoomScaleFactor;
    CGFloat scale = frameNumber * M_PI / 1.0e12;

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
    glColor4f(solarColor.redComponent, solarColor.greenComponent, solarColor.blueComponent, 1.0f);
    CGFloat solarRadius = MAX(5, [star radius] * metersToPixelsScale);
    [view drawCircleWithRadius:solarRadius centerX:x centerY:y];

    glColor4f(0.1f, 0.65f, 0.1f, 1.0f);
    CGFloat innerRadius = star.habitableZoneInnerRadius * metersToPixelsScale;
    CGFloat outerRadius = star.habitableZoneOuterRadius * metersToPixelsScale;
    [view drawTorusAtPoint:NSMakePoint(x, y) innerRadius:innerRadius outerRadius:outerRadius];

    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        [view drawOrbitForPlanet:planet atScale:zoomScaleFactor atOrigin:[origin currentValue]];
    }];

    [[system planetoids] enumerateObjectsUsingBlock:^(GLGPlanetoid *planet, NSUInteger index, BOOL *stop) {
        [self drawTrailersForPlanet:planet onView:view];

        CGFloat radius = MAX([planet radius] * metersToPixelsScale * 10000, 1);

        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

        pxp = px * cos(planet.rotationAngleAroundStar) - py * sin(planet.rotationAngleAroundStar);
        pyp = px * sin(planet.rotationAngleAroundStar) + py * cos(planet.rotationAngleAroundStar);

        CGFloat translated_x = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat translated_y = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        pxp -= (translated_x - x);
        pyp -= (translated_y - y);

        glColor3f(planet.color.redComponent, planet.color.greenComponent, planet.color.blueComponent);
        [view drawCircleWithRadius:radius centerX:pxp centerY:pyp];
    }];

}

- (void) drawTrailersForPlanet:(GLGPlanetoid *) planet onView:(GLGOpenGLView *) view{
    // draw each of the trailers
    // and update their positions
    // say each of these will be visible for 10 frames

    // behavior is basically to have a trail of trailing frames
    // every 10 (say) frames, phase out the last one and emit a new one at
    // the previous position (basically using a ring buffer?)
    // this means that the alpha should fade out as it gets to the edge (probably logarithmic)
    // probably means that I should have more than ~10 frames to make this more seemless
    [planet tick];

    CGFloat __block x, y, px, py, pxp, pyp;
    NSUInteger count = [[planet trailers] count];
    CGFloat zoomScaleFactor = powf(1.01, [zoomScale currentValue]);
    CGFloat metersToPixelsScale = 3.543e-9 * zoomScaleFactor;

    NSPoint currentOrigin = [origin currentValue];
    x = view.bounds.size.width / 2 + currentOrigin.x;
    y = view.bounds.size.height / 2 + currentOrigin.y;

    [[planet trailers] enumerateObjectsUsingBlock:^(GLGPsychedeliaTrailer *trail, NSUInteger index, BOOL *stop) {
        CGFloat scale = (frameNumber - (count - index)) * M_PI / 1.0e12;

        CGFloat radius = MAX([planet radius] * metersToPixelsScale * 10000, 1);
        px = x + planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
        py = y + planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

        pxp = px * cos(planet.rotationAngleAroundStar) - py * sin(planet.rotationAngleAroundStar);
        pyp = px * sin(planet.rotationAngleAroundStar) + py * cos(planet.rotationAngleAroundStar);

        CGFloat translated_x = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat translated_y = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        pxp -= (translated_x - x);
        pyp -= (translated_y - y);

        glColor4f(trail.color.redComponent, trail.color.greenComponent, trail.color.blueComponent, 0.1f);
        [view drawCircleWithRadius:radius centerX:pxp centerY:pyp];
    }];
}

- (void) systemWasSelected:(GLGSolarSystem *) system {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [zoomScale setCurrentValue:-500 animate:NO];
    [origin setPoint:NSMakePoint(0, 0)];

    if (system == nil) {
        activeSystemIndex = -1;
        [nc postNotificationName:@"glg_did_resign_system" object:nil];
    }
    else {
        activeSystemIndex = [solarSystems indexOfObject:system];
        [nc postNotificationName:@"glg_did_select_system" object:system];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"glg_sidebar_system_selected" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"glg_did_resign_planet" object:self];

    selectedPlanet = nil;
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

- (NSMutableArray *) solarSystems {
    return solarSystems;
}

- (void) startViewingPlanet:(GLGPlanetoid *) planet {
    assert( [self.activeSystem.planetoids indexOfObject:planet] >= 0 );

    [zoomScale setCurrentValue:-400 animate:YES];
    CGFloat animationTime = 0.75; // less hardcoded please
    NSInteger framesToComplete = floor(animationTime * 30.0);
    NSInteger animationCompleteFrame = frameNumber + framesToComplete;

    CGFloat zoomScaleFactor = powf(1.01, -400);
    CGFloat metersToPixelsScale = 3.543e-9 * zoomScaleFactor;
    CGFloat scale = animationCompleteFrame * 2 * M_PI / 2.0e12;

    CGFloat planetX = -1 * planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
    CGFloat planetY = -1 * planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

    void (^completionHandler)(void) = ^(void) {
        selectedPlanet = planet;
    };

    [origin easeToPoint:NSMakePoint(planetX, planetY) withBlock:completionHandler];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"glg_did_select_planet" object:planet];
}

- (void) stopViewingPlanet {
    [zoomScale setCurrentValue:-500 animate:YES];
    [origin easeToPoint:NSMakePoint(0, 0)];

    selectedPlanet = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"glg_did_resign_planet" object:nil];
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

- (void) didSelectSystem:(NSNotification *) notification {
    GLGSolarSystem *system = (GLGSolarSystem *)[notification object];
    NSString *newTitle = [NSString stringWithFormat:@"Choose a galaxy to colonize > Pick a planet in %@ >", [system name]];
    [title setStringValue:newTitle];
}

- (void) didResignSystem {
    [title setStringValue:@"Choose a galaxy to colonize >"];
}

- (void) keyWasPressed:(unsigned short) key {
    switch (key) {
        case 49:
            [self pause];
            break;
        case 11:
            [self expandOrCollapseSidebar];
            break;
    }
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
