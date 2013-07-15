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
@protocol GLGSidebarPlanetDelegate;

@interface GLGSidebarPlanetDetail : NSView {
    GLGPlanetoid *planet;
    NSButton *disclosureButton;
    GLGLabel *planetName;
    id <GLGSidebarPlanetDelegate> delegate;
}

- (id) initWithPlanet:(GLGPlanetoid *)planet;
- (void) setDelegate:(id) _delegate;

@end

@protocol GLGSidebarPlanetDelegate <NSObject>
@required
- (void) startViewingPlanet:(GLGPlanetoid *) planet;
- (void) stopViewingPlanet;
@end