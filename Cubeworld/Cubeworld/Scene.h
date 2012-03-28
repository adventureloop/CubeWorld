//
//  Scene.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scene : NSObject
{
    NSTimer *animationTimer;
}

-(id)initWithBounds:(CGRect) newBounds;

-(void)startAnimating;
-(void)stopAnimating;
-(void)update;
-(void)render;

-(void)setupOpenGL;
-(void)didResizeTo:(CGRect)newBounds;

-(void)keyDown:(int)keyCode;
-(void)keyUp:(int)keyCode;
-(void)mouseMovedByX:(int)x Y:(int)y;

@property CGRect bounds;
@end
