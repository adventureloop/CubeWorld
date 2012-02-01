//
//  OpenGLView.m
//  Cubeworld
//
//  Created by Tom Jones on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"
#include <OpenGL/gl.h>

@implementation OpenGLView
-(id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format
{
    if(self = [super initWithFrame:frameRect pixelFormat:format]) {
    }
    
    return self;
}

-(void)drawRect:(NSRect)bounds
{
    glViewport(0, 0, (GLsizei) bounds.size.width, (GLsizei) bounds.size.width);
    
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0f, 1.0f, 1.0f);
    glBegin(GL_TRIANGLES);
    {
        glVertex3f(0.0,0.0,0.0);
        glVertex3f(0.5,1.0,0.0);
        glVertex3f(1.0,0.0,0.0);
    }
    glEnd();
    glFlush();
}
@end
