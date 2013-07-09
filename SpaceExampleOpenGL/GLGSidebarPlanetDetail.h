//
//  GLGSidebarPlanetDetail.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/8/13.
//
//

#import <Cocoa/Cocoa.h>
#import "GLGLabel.h"

@class GLGPlanetoid;

@interface GLGSidebarPlanetDetail : NSView {
    GLGPlanetoid *planet;
    NSButton *disclosureButton;
    GLGLabel *planetName;
    id delegate;
}

- (id) initWithPlanet:(GLGPlanetoid *)planet;
- (void) setDelegate:(id) _delegate;

@end
