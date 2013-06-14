//
//  BasicOpenGLView.m
//  SpaceExampleOpenGL
//
//  Created by Tim Jarratt on 6/13/13.
//
//

#import "BasicOpenGLView.h"

@implementation BasicOpenGLView

- (void)drawRect:(NSRect)dirtyRect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
}

static void drawAnObject() {
    glColor3f( 1.0f, 0.85f, 0.35f);
    glBegin(GL_TRIANGLES);
    {
        glVertex3f( 0.0, 0.6, 0.0);
        glVertex3f( -0.2, -0.3, 0.0);
        glVertex3f( 0.2, -0.3, 0.0);
    }
    glEnd();
}

@end
