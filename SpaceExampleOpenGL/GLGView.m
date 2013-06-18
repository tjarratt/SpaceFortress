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
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);

    [self drawAnObject];
    
    glFlush();

}

- (void) drawAnObject {
    glColor3f(1.0f, 0.85f, 0.35f);
    glBegin(GL_TRIANGLES);
    {
        glVertex3f(0.0, 0.6, 0.0);
        glVertex3f(-0.2, -0.3, 0.0);
        glVertex3f(0.2, -0.3, 0.0);
    }
    glEnd();
}

@end
