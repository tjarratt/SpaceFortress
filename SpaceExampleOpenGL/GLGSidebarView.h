//
//  GLGSidebarView.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import <Cocoa/Cocoa.h>
#import "GLGSolarSystem.h"
#import "GLGFlippedView.h"
#import "GLGSidebarGalaxyView.h"
#import "GLGSidebarConstants.h"

@class GLGSolarSystem;

@interface GLGSidebarView : NSScrollView {
    NSView *innerView;
    NSMutableArray *subViews;
    NSMutableArray *systems;

    GLGLabel *framerateValue;
    NSTextField *framerateLabel;

    NSRect expandedRect;
    NSRect collapsedRect;
}

@property BOOL collapsed;

- (void) expandOrCollapse;

@end
