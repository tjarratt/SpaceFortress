//
//  GLGPlanetSidebar.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import "GLGPlanetSidebar.h"

@implementation GLGPlanetSidebar

- (id) initWithFrame:(NSRect) frame andDelegate:(GLGPlanetActor *) delegate {
    if (self = [super initWithFrame:frame]) {
        self.collapsed = YES;
    }

    return self;
}

@end
