//
//  GLGGalaxySidebar.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 7/16/13.
//
//

#import "GLGSidebarView.h"

@class GLGGalaxyPickerActor;
@protocol GLGGalaxySidebarDelegate;

@interface GLGGalaxySidebar : GLGSidebarView {
    id <GLGGalaxySidebarDelegate> delegate;
}

- (id) initWithFrame:(NSRect) frame;
- (void) setDelegate:(id) _delegate;

@end

#pragma mark - delegate procol
@protocol GLGGalaxySidebarDelegate <NSObject>
@required
- (id) solarSystems;
- (NSUInteger) activeSystemIndex;

@end
