//
//  MainScene.m
//  Cubeworld
//
//  Created by Tom Jones on 28/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

-(id)initWithBounds:(CGRect)newBounds
{
    if(self = [super initWithBounds:newBounds]){
        world = [[WorldScene alloc]initWithBounds:newBounds];
        [self startAnimating];
    }
    return self;
}

-(void)render
{
    [world render];
}

-(void)startAnimating
{
    self->animationTimer = [NSTimer scheduledTimerWithTimeInterval:1/30 target:self selector:@selector(render) userInfo:nil repeats:YES];
}

-(void)stopAnimating;
{
    [animationTimer release];
}

-(void)didResizeTo:(CGRect)newBounds
{
    [world didResizeTo:newBounds];
}

-(void)keyDown:(int)keyCode
{
    [world keyDown:keyCode];
}

-(void)keyUp:(int)keyCode
{
    [world keyUp:keyCode];
}

-(void)mouseMovedByX:(int)x Y:(int)y
{
    [world mouseMovedByX:x Y:y];
}
@end
