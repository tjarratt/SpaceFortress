//
//  GLGSidebarView.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/25/13.
//
//

#import <Cocoa/Cocoa.h>
#import "GLGSolarSystem.h"

@interface GLGSidebarView : NSView
- (id)initWithFrame:(NSRect)frame system: (GLGSolarSystem *)system andDelegate:(id)delegate;
@end
