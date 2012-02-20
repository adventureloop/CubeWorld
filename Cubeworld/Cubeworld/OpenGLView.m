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
    
}

-(void)drawRect:(NSRect)bounds
{
    [scene render];
    
    if(scene == nil)
        scene = [[Scene alloc]initWithBounds:[self bounds]];
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
    //NSLog(@"Key released: %@", event);
}

-(void)keyDown:(NSEvent*)event
{   
}
@end
