 //
//  GLGView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/18/13.
//
//

#import "GLGView.h"

@implementation GLGView

- (void) setDelegate: (id) _delegate {
    delegate = _delegate;
}

- (void) keyDown:(NSEvent *)theEvent {
    if (delegate) {
        [delegate keyWasPressed:theEvent];
    }
}

- (void) update {
    
}

- (void) drawRect:(NSRect)dirtyRect
{
    glDisable(GL_DEPTH_TEST);
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);

    if (delegate && [delegate respondsToSelector:@selector(BasicOpenGLView:drawInRect:)]) {
        [delegate BasicOpenGLView:self drawInRect:dirtyRect];
    }
    
    glFlush();
    CGLFlushDrawable([[self openGLContext] CGLContextObj]);
}

- (void) reshape {
    if (delegate && [delegate respondsToSelector:@selector(BasicOpenGLViewDidReshape:)]) {
        [delegate BasicOpenGLViewDidReshape: self];
    }
}

-(void) drawCircleWithRadius: (CGFloat)radius centerX:(CGFloat)cx centerY:(CGFloat)cy {
    glBegin(GL_TRIANGLE_FAN);

    int num_segments = 100;
    CGFloat scale = 2 * M_PI / (float) num_segments;
    
    glVertex2f(cx, cy);
    for (int i = 0; i <= num_segments; ++i) {
        glVertex2f(cx + radius * cos(i * scale), cy + radius * sin(i * scale));
    }
    
    glEnd();
    
}

- (void) drawOrbitForPlanet:(GLGPlanetoid *)planet atPointX:(CGFloat) px pointY:(CGFloat) py {
    glPushAttrib(GL_ENABLE_BIT);
    glLineStipple(10, 0xAAAA);
    glEnable(GL_LINE_STIPPLE);
    glBegin(GL_LINES);
    
    CGFloat ox, oy, oxp, oyp;
    CGFloat x = self.bounds.size.width / 2;
    CGFloat y = self.bounds.size.height / 2;
    CGFloat meters_to_pixels_scale = 3.543e-11;
    
    glColor3f(1, 1, 1);
    for (CGFloat i = -2 * M_PI; i < 2 * M_PI; i+= 0.1) {
        ox = x + planet.apogee_meters * meters_to_pixels_scale * cos(i + planet.rotation_angle_around_star);
        oy = y + planet.perogee_meters * meters_to_pixels_scale * sin(i + planet.rotation_angle_around_star);
        
        oxp = ox * cos(planet.rotation_angle_around_star) - oy * sin(planet.rotation_angle_around_star);
        oyp = ox * sin(planet.rotation_angle_around_star) + oy * cos(planet.rotation_angle_around_star);
        
        CGFloat tx = x * cos(planet.rotation_angle_around_star) - y * sin(planet.rotation_angle_around_star);
        CGFloat ty = x * sin(planet.rotation_angle_around_star) + y * cos(planet.rotation_angle_around_star);
        
        oxp -= tx - x;
        oyp -= ty - y;
        
        glVertex2f(oxp, oyp);
    }
    
    glEnd();
    
    glPopAttrib();
}

@end
