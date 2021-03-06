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

@interface GLGOpenGLView : NSOpenGLView {
    id<GLGOpenGLViewDelegate> delegate;
    CGFloat rotation;
}

- (void) setDelegate: (id) delegate;
- (void) drawCircleWithRadius: (CGFloat)radius centerX:(CGFloat)cx centerY:(CGFloat)cy;
- (void) drawOrbitForPlanet:(GLGPlanetoid *) planet atScale:(CGFloat) scale atOrigin:(CGPoint) origin;
- (void) drawTorusAtPoint:(CGPoint) center innerRadius:(CGFloat) innerRadius outerRadius:(CGFloat) outerRadius;
- (void) drawPolarRectAtPoint:(CGFloat) point withLength:(CGFloat) length atHeight:(CGFloat) height withCenter:(NSPoint) center;

- (void) setRotation:(CGFloat) _rotation;

#pragma mark - scroll delegate events
- (void) scrollWheel:(NSEvent *) event;

@end

#pragma mark - delegate interface
@protocol GLGOpenGLViewDelegate <NSObject>

@required
- (void) prepareOpenGL;
- (void) keyWasPressed:(NSEvent *) event;
- (void) didZoom:(CGFloat) amount;
- (void) didPanByVector:(CGPoint) vector;
- (void) GLGOpenGLView:(GLGOpenGLView *) view drawInRect:(NSRect) rect;
- (void) GLGOpenGLViewDidReshape:(GLGOpenGLView *) view;
- (void) handleMouseUp;
- (void) handleMouseDown:(NSPoint) point;

@end
