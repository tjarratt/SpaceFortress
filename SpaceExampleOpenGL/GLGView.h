//
//  GLGView.h
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import <OpenGL/gl.h>
#import <Cocoa/Cocoa.h>
#import "GLGPlanetoid.h"

@protocol GLGOpenGLViewDelegate;

@interface GLGView : NSOpenGLView {
    id delegate;
}

- (void) setDelegate: (id) delegate;
- (void) drawCircleWithRadius: (CGFloat)radius centerX:(CGFloat)cx centerY:(CGFloat)cy;
- (void) drawOrbitForPlanet:(GLGPlanetoid *) planet atPointX:(CGFloat) px pointY:(CGFloat) py;

@end

#pragma mark - delegate interface
@protocol GLGOpenGLViewDelegate <NSObject>

@required
- (void)prepareOpenGL;

@optional
- (void)GLGOpenGLView:(NSOpenGLView *)view drawInRect:(NSRect)rect;
- (void)GLGOpenGLViewDidReshape:(NSOpenGLView *)view;


@end
