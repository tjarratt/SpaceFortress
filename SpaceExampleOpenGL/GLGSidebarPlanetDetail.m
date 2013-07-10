//
//  GLGSidebarPlanetDetail.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/8/13.
//
//

#import "GLGSidebarPlanetDetail.h"

@implementation GLGSidebarPlanetDetail

- (id) initWithPlanet:(GLGPlanetoid *) _planet {
    if (self = [super init]) {
        planet = _planet;

        disclosureButton = [[NSButton alloc] initWithFrame:NSMakeRect(5, 5, 20, 25)];
        [disclosureButton setTitle:@""];
        [disclosureButton setState:NSOnState];
        [disclosureButton setButtonType:NSPushOnPushOffButton];
        [disclosureButton setBezelStyle:NSRoundedDisclosureBezelStyle];
        [disclosureButton setTarget:self];
        [disclosureButton setAction:@selector(openedPlanetDisclosure)];
        [self addSubview:disclosureButton];

        planetName = [[GLGLabel alloc] initWithFrame:NSMakeRect(30, 5, 150, 25)];
        [planetName setStringValue:[planet name]];
        [self addSubview:planetName];
    }
    
    return self;
}

- (BOOL) isFlipped {
    return YES;
}

- (void) setDelegate:(id) _delegate {
    delegate = _delegate;
}

- (void) openedPlanetDisclosure {
    // logic is backwards because the state is currently changing
    if ([disclosureButton state] == NSOnState) {
        [delegate stopViewingPlanet];
    }
    else {
        [delegate startViewingPlanet: planet];
    }
}

@end
