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

-(void)awakeFromNib
{
    NSLog(@"Setting up opengl");   
    captureMouse = YES;
    
}

-(void)drawRect:(NSRect)bounds
{
    if(scene == nil) {
        GLint swapInt = 1;
        [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
        scene = [[MainScene alloc]initWithBounds:[self bounds]];
        [scene startAnimating];
    }
    [scene render];
}

-(void)viewDidEndLiveResize
{
    [scene didResizeTo:[self bounds]];
}

#pragma mark Handle keypresses
- (BOOL)acceptsFirstResponder // required if you want to get keydown event in NSViews.
{
    return YES;
}

-(void)keyUp:(NSEvent*)event
{
    [scene keyUp:[event keyCode]];
}

-(void)keyDown:(NSEvent*)event
{   
    [scene keyDown:[event keyCode]];
}

-(void)mouseMoved:(NSEvent *)theEvent
{
   // NSLog(@"%@",theEvent);
    
    if(captureMouse)
        [scene mouseMovedByX:[theEvent deltaX] Y:[theEvent deltaY]];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    captureMouse = YES;
}

-(void)mouseExited:(NSEvent *)theEvent
{
    captureMouse = NO;
}
@end
