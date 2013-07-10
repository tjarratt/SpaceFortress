//
//  GLGSidebarGalaxyView.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/3/13.
//
//

#import <Cocoa/Cocoa.h>

#import "GLGLabel.h"
#import "GLGSolarStar.h"
#import "GLGSolarSystem.h"
#import "GLGSidebarPlanetDetail.h"

@interface GLGSidebarGalaxyView : NSView {
    id delegate;
    NSMutableArray *planetDetailViews;

    GLGLabel *galaxyName;
    GLGLabel *starTypeField;
    GLGLabel *numPlanets;
}

@property (readonly, retain) GLGSolarSystem* galaxy;
@property BOOL open;
@property BOOL selected;

- (id) initWithFrame:(NSRect)frameRect delegate:(id) theDelegate andSystem:(GLGSolarSystem *) system;
- (void) animateToFrame:(NSRect) frameRect;
@end
