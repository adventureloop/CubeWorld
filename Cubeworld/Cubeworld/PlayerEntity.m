//
//  PlayerEntity.m
//  Cubeworld
//
//  Created by Tom Jones on 09/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerEntity.h"

@implementation PlayerEntity

-(id)init
{
    if(self = [super initWithMesh:nil] ) {
        moveSpeed = 1.0;
        lookSpeed = 5.0;
    }
    return self;
}

-(vec3 *)playerRotation
{
    return &rotation;
}

-(void)setOldLocation:(vec3 *)old
{
    oldLocation.x = old->x;
    oldLocation.y = old->y;
    oldLocation.z = old->y;
}


#pragma mark control player movement
-(void)unmove
{
    [self setLocation:&oldLocation];
}

-(void)moveForward
{
    [self setOldLocation:&location];
    location.z += moveSpeed;
}

-(void)moveBackward
{
    [self setOldLocation:&location];
    location.z -= moveSpeed;
}

-(void)moveRight
{ 
    [self setOldLocation:&location];
    location.x += moveSpeed;
}

-(void)moveLeft
{ 
    [self setOldLocation:&location];
    location.x -= moveSpeed;
}

-(void)moveUp
{
    [self setOldLocation:&location];
    location.y += moveSpeed;
}

-(void)moveDown
{
    [self setOldLocation:&location];
    location.y -= moveSpeed;
}

#pragma mark change look direction;
-(void)lookUp
{
    rotation.x += lookSpeed;
}

-(void)lookDown
{
    rotation.x -= lookSpeed;
}

-(void)lookRight
{
    rotation.y += lookSpeed;
}

-(void)lookLeft
{
    rotation.y -= lookSpeed;
}

@end
