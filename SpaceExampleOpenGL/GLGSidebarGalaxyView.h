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

@interface GLGSidebarGalaxyView : NSView {
    id delegate;
    NSButton *disclosureTriangle;
}

@property (readonly, retain) GLGSolarSystem* galaxy;
@property BOOL open;
@property BOOL selected;

- (id) initWithFrame:(NSRect)frameRect delegate:(id) theDelegate andSystem:(GLGSolarSystem *) system;
@end
