 //
//  GLGView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGView.h"

@implementation GLGView

- (id) initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setAcceptsTouchEvents:YES];
    }
    return self;
}

- (void) setDelegate: (id) _delegate {
    delegate = _delegate;
}

- (void) keyDown:(NSEvent *)theEvent {
    if (delegate) {
        [delegate keyWasPressed:theEvent];
    }
}

- (void) drawRect:(NSRect)dirtyRect
{
    glDisable(GL_DEPTH_TEST);
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);

    if (delegate && [delegate respondsToSelector:@selector(GLGOpenGLView:drawInRect:)]) {
        [delegate GLGOpenGLView:self drawInRect:dirtyRect];
    }
    
    glFlush();
    CGLFlushDrawable([[self openGLContext] CGLContextObj]);
}

- (void) reshape {
    if (delegate && [delegate respondsToSelector:@selector(GLGOpenGLViewDidReshape:)]) {
        [delegate GLGOpenGLViewDidReshape: self];
    }
}

-(void) drawCircleWithRadius: (CGFloat)radius centerX:(CGFloat)cx centerY:(CGFloat)cy {
    glBegin(GL_TRIANGLE_FAN);

    int segments = 100;
    CGFloat scale = 2 * M_PI / (float) segments;
    
    glVertex2f(cx, cy);
    for (int i = 0; i <= segments; ++i) {
        glVertex2f(cx + radius * cos(i * scale), cy + radius * sin(i * scale));
    }
    
    glEnd();
    
}

- (void) drawTorusAtPoint:(CGPoint) center innerRadius:(CGFloat) innerRadius outerRadius:(CGFloat) outerRadius {
    glBegin(GL_TRIANGLE_STRIP);
    
    int segments = 100;
    CGFloat scale = 2 * M_PI / (float) segments;
    
    for (int i = 0; i <= segments; ++i) {
        glVertex2f(center.x + innerRadius * cos(i * scale), center.y + innerRadius * sin(i * scale));
        glVertex2f(center.x + outerRadius * cos(i * scale), center.y + outerRadius * sin(i * scale));
    }
    
    glEnd();
}

- (void) drawOrbitForPlanet:(GLGPlanetoid *)planet atScale:(CGFloat)scale atOrigin:(CGPoint) origin {
    glPushAttrib(GL_ENABLE_BIT);
    glLineStipple(10, 0x1111);
    glEnable(GL_LINE_STIPPLE);

    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glLineWidth(3.0f);
    glHint(GL_NICEST, GL_LINE_SMOOTH_HINT);
    
    glBegin(GL_LINES);
    
    CGFloat ox, oy, oxp, oyp;
    CGFloat x = self.bounds.size.width / 2 + origin.x;
    CGFloat y = self.bounds.size.height / 2 + origin.y;
    CGFloat metersToPixelsScale = 3.543e-11 * scale;
    
    glColor3f(1, 1, 1);
    for (CGFloat i = -2 * M_PI; i < 2 * M_PI; i+= 0.1) {
        ox = x + planet.apogeeMeters * metersToPixelsScale * cos(i + planet.rotationAngleAroundStar);
        oy = y + planet.perogeeMeters * metersToPixelsScale * sin(i + planet.rotationAngleAroundStar);
        
        oxp = ox * cos(planet.rotationAngleAroundStar) - oy * sin(planet.rotationAngleAroundStar);
        oyp = ox * sin(planet.rotationAngleAroundStar) + oy * cos(planet.rotationAngleAroundStar);
        
        CGFloat tx = x * cos(planet.rotationAngleAroundStar) - y * sin(planet.rotationAngleAroundStar);
        CGFloat ty = x * sin(planet.rotationAngleAroundStar) + y * cos(planet.rotationAngleAroundStar);
        
        oxp -= tx - x;
        oyp -= ty - y;
        
        glVertex2f(oxp, oyp);
    }
    
    glEnd();
    
    glPopAttrib();
}

- (void) drawPolarRectAtPoint:(CGFloat) point withLength:(CGFloat) length atHeight:(CGFloat) height withCenter:(NSPoint) center {
    glBegin(GL_TRIANGLE_FAN);
    CGFloat radius = 200;
    assert( length <= radius * 2 * M_PI );

    CGFloat fullHeight = height * 25;

    // convention: 0 is at 12 o'clock ->
    CGFloat segments = 100;
    CGFloat percentageOfCircumference = length / (radius * 2 * M_PI);
    CGFloat scale = percentageOfCircumference / segments;

    CGFloat innerRadius = radius + fullHeight;
    CGFloat outerRadius = innerRadius + 25;

    // for each point, along the circumference, draw the inner and outer portions
    // this is basically just like drawing a torus, except that we don't 2 * PI * R
    for (int i = 0; i <= segments; ++i) {
        glVertex2f(center.x + innerRadius * cos(i * scale + point), center.y + innerRadius * sin(i * scale + point));
        glVertex2f(center.x + outerRadius * cos(i * scale + point), center.y + outerRadius * sin(i * scale + point));
    }

    glEnd();
}


#pragma mark - touch, scroll and mouse events
- (void) scrollWheel:(NSEvent *) event {
    if (delegate) {
        [delegate didZoom:[event deltaY]];
    }
}

- (void) mouseDragged:(NSEvent *)theEvent {
    if (delegate) {
        [delegate didPanByVector:CGPointMake(1.5 * theEvent.deltaX, -1.5f * theEvent.deltaY)];
    }
}

@end
