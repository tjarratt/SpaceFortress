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
    if (delegate && [delegate respondsToSelector:@selector(BasicOpenGLView:drawInRect:)]) {
        [delegate BasicOpenGLView:self drawInRect:dirtyRect];
    }
    
    [self drawObjects];
    
    glFlush();
    CGLFlushDrawable([[self openGLContext] CGLContextObj]);
}

- (void) reshape {
    if (delegate && [delegate respondsToSelector:@selector(BasicOpenGLViewDidReshape:)]) {
        [delegate BasicOpenGLViewDidReshape: self];
    }
}
    
-(void) drawObjects {
    glDisable(GL_DEPTH_TEST);
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);

    [self drawStar];
    [self drawPlanets];
    
    glFlush();
}

- (void) drawStar {
    glColor3f(1.0f, 0.85f, 0.35f);
    glBegin(GL_TRIANGLE_FAN);

    CGFloat cx = self.bounds.size.width / 2;
    CGFloat cy = self.bounds.size.height / 2;
    NSLog(@"creating a sun at %f, %f", cx, cy);
    
    int radius = 50;
    int num_segments = 100;
    CGFloat scale = 2 * M_PI / (float) num_segments;
    
    glVertex2f(cx, cy);
    for (int i = 0; i <= num_segments; ++i) {
        glVertex2f(cx + radius * cos(i * scale), cy + radius * sin(i * scale));
    }
    
    glEnd();
}

- (void) drawPlanets {
    glColor3f(0.5f, 0.85f, 0.35f);
    glBegin(GL_TRIANGLE_FAN);

    CGFloat cx = self.bounds.size.width / 2 - 200;
    CGFloat cy = self.bounds.size.width / 2 - 200;
    NSLog(@"creating a planet at %f, %f", cx, cy);
    
    int radius = 25;
    int num_segments = 100;
    CGFloat scale = 2 * M_PI / (float) num_segments;

    glVertex2f(cx, cy);
    for(int i = 0; i <= num_segments; ++i) {
        glVertex2f(cx + radius * cos(i * scale), cy + radius * sin(i * scale));
    }
    
    glEnd();
}

@end
