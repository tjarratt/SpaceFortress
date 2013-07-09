//
//  GLGSidebarView.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import <Cocoa/Cocoa.h>
#import "GLGSolarSystem.h"
#import "GLGSidebarGalaxyView.h"

@class GLGSolarSystem;

@interface GLGSidebarView : NSScrollView {
    NSView *innerView;
    NSMutableArray *subViews;
    NSMutableArray *systems;
}

- (id)initWithFrame:(NSRect)frame systems:(NSMutableArray *)systems andDelegate:(id)delegate;
- (void) didSelectObjectAtIndex:(NSInteger) index;
@end
