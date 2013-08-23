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
@synthesize activeSystemIndex;
@synthesize wantsPsychedelia;

const NSUInteger solarSystemCapacity = 3;

- (id) initWithWindow:(NSWindow *) _window {
    if (self = [self init]) {
        [self setWantsPsychedelia:NO];
        window = _window;
        self.zoomScale = [[GLGEasedValue alloc] initWithValue: -500.0f];
        [self.zoomScale setMinimum:-100000.0f];
        [self.zoomScale setMaximum:100000.0];

        [self setOrigin:[[GLGEasedPoint alloc] initWithPoint:NSMakePoint(0, 0)]];
        [self.origin setMinimum:NSMakePoint(-1200, -1200)];
        [self.origin setMaximum:NSMakePoint(1200, 1200)];

        speedOfTime = [[GLGEasedValue alloc] initWithValue:1.0];
        [speedOfTime setMinimum:0.1];
        [speedOfTime setMaximum:2.0];

        frameNumber = 0;
        framerate = 0.0f;
        frameCount = 0;

        NSSize frameSize = _window.frame.size;
        expandedSceneRect = NSMakeRect(0, 0, frameSize.width - sidebarWidth, frameSize.height - 50);
        collapsedSceneRect = NSMakeRect(expandedSceneRect.origin.x, expandedSceneRect.origin.y, expandedSceneRect.size.width + sidebarWidth - 10, expandedSceneRect.size.height);

        planetSizeWeight = 10000;

        activeSystemIndex = -1;
        [self initializeSolarSystems];

        CGFloat rectWidth = _window.frame.size.width;
        CGFloat rectHeight = _window.frame.size.height;
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

- (void) removeSubviews {
    if (quitButton) {
        [quitButton removeFromSuperview];
        [quitButton release];
    }

    [title removeFromSuperview];
    [titleView removeFromSuperview];
    title = nil;
    titleView = nil;

    [sidebar removeFromSuperview];
    [sidebar release];

}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObject:self];
    [self removeSubviews];
    [super dealloc];
}

- (void) setDelegate:(id) _delegate {
    delegate = _delegate;
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
    if (frameCount == lastFrame) {
        return;
    }

    double currentTime = CFAbsoluteTimeGetCurrent();
    double diff = currentTime - lastTimestamp;
    double rate = (frameCount - lastFrame) / diff;
    [self setFramerate: round(rate * 100) / 100.0f];

    lastFrame = frameCount;
    lastTimestamp = currentTime;

}

- (void) incrementFrameNumber {
    if ([self paused]) { return; }

    frameCount += 1;
    frameNumber += 1 * [speedOfTime currentValue];
}

- (NSUInteger) frameNumber {
    return frameNumber;
}

- (void) systemWasSelected:(GLGSolarSystem *) system {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [self.zoomScale setCurrentValue:-500 animate:NO];
    [self.origin setPoint:NSMakePoint(0, 0)];

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

    [self setSelectedPlanet:nil];
}

- (void) initializeSolarSystems {
    [self setSelectedPlanet:nil];
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

    [self.zoomScale setCurrentValue:-400 animate:YES];
    CGFloat animationTime = 0.75; // less hardcoded please
    NSInteger framesToComplete = floor(animationTime * 60.0);
    NSInteger animationCompleteFrame = frameNumber + framesToComplete;

    CGFloat zoomScaleFactor = powf(1.01, -400);
    CGFloat metersToPixelsScale = 3.543e-9 * zoomScaleFactor;
    CGFloat scale = animationCompleteFrame * 2 * M_PI / 2.0e12;

    CGFloat planetX = -1 * planet.apogeeMeters * metersToPixelsScale * cos(scale * planet.rotationAroundSolarBodySeconds);
    CGFloat planetY = -1 * planet.perogeeMeters * metersToPixelsScale * sin(scale * planet.rotationAroundSolarBodySeconds);

    void (^completionHandler)(void) = ^(void) {
        [self setSelectedPlanet:planet];
    };

    [self.origin easeToPoint:NSMakePoint(planetX, planetY) withBlock:completionHandler];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"glg_did_select_planet" object:planet];
}

- (void) stopViewingPlanet {
    [self.zoomScale setCurrentValue:-500 animate:YES];
    [self.origin easeToPoint:NSMakePoint(0, 0)];

    [self setSelectedPlanet:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"glg_did_resign_planet" object:nil];
}

- (void) didZoom:(CGFloat) amount {
    if ([self paused]) { return; }

    [self.zoomScale incrementBy:amount];
}

- (void) didPanByVector:(CGPoint) vector {
    if ([self paused]) { return; }

    if ([self selectedPlanet] == nil) {
        [self.origin addVector:vector];
    }
}

#pragma mark - UI Observer binding methods
- (GLGSolarSystem *) activeSystem {
    if (activeSystemIndex < 0) { return nil; }

    return [solarSystems objectAtIndex:activeSystemIndex];
}

+ (NSSet *) keyPathsForValuesAffectingValueForKey:(NSString *) key {
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
        case 24:
        {
            CGFloat newSpeed = [speedOfTime currentValue] + 0.2;
            [speedOfTime setCurrentValue:newSpeed animate:YES];
        }
            break;
        case 27:
        {
            CGFloat newSpeed = [speedOfTime currentValue] - 0.2;
            [speedOfTime setCurrentValue:newSpeed animate:YES];
        }
            break;
        case 53:
            [self pause]; // don't leak memory if you unpause while in this state
            if ([self paused]) {
                NSSize frameSize = [[window contentView] frame].size;
                NSPoint center = NSMakePoint(frameSize.width / 2, frameSize.height / 2);
                CGFloat width = 200;
                CGFloat height = 50;
                quitButton = [[NSButton alloc] initWithFrame:NSMakeRect(center.x - width / 2, center.y - height / 2, width, height)];
                [quitButton setTitle:@"Quit"];
                [quitButton setTarget:self];
                [quitButton setAction:@selector(quit)];
                [[window contentView] addSubview:quitButton];
            }
            else {
                [quitButton removeFromSuperview];
                [quitButton release];
            }
    }
}

- (void) quit {
    [self removeSubviews];
    [delegate switchToMainMenuView];
}

- (void) expandOrCollapseSidebar {
    if ([self paused]) {
        return;
    }

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
