//
//  GLGPlanetSidebar.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import "GLGSidebarView.h"
#import "GLGPlanetActor.h"

@class GLGPlanetActor;

@interface GLGPlanetSidebar : GLGSidebarView

- (id) initWithFrame:(NSRect) frame andDelegate:(GLGPlanetActor *) delegate;

@end
