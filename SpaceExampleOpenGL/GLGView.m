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

@end
