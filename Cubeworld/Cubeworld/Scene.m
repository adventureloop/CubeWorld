//
//  Scene.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Scene.h"
#include <OpenGL/gl.h>
#import <Carbon/Carbon.h>

@implementation Scene
@synthesize bounds;

-(id)initWithBounds:(CGRect)newBounds
{
    if(self = [super init]) {
    }
    return self;
}

-(void)startAnimating
{
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(render) userInfo:nil repeats:YES];
}

-(void)stopAnimating;
{
    [animationTimer release];
}

-(void)update
{
}

-(void)render
{
}

-(void)setupOpenGL
{
}

-(void)didResizeTo:(CGRect)newBounds
{
}


#pragma mark Handle key presses
-(void)keyDown:(int)keyCode
{
}

-(void)keyUp:(int)keyCode
{
}

#pragma mark Mouse handling stuff
-(void)mouseMovedByX:(int)x Y:(int)y
{
}
@end
