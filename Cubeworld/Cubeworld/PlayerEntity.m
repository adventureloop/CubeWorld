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
    [self calculateLookVec];
    
    location.z -= (lookVec.z * moveSpeed);
    location.x += lookVec.x * moveSpeed;
    
    
}

-(void)moveBackward
{
    [self setOldLocation:&location];
    [self calculateLookVec];
    
    location.z += lookVec.z * moveSpeed;
    location.x -= lookVec.x * moveSpeed;
}

-(void)moveRight
{ 
    [self setOldLocation:&location];
    [self calculateLookVec];
    
    location.z += lookVec.x * moveSpeed;
    location.x += lookVec.z * moveSpeed;
}

-(void)moveLeft
{ 
    [self setOldLocation:&location];
    [self calculateLookVec];
    
    location.z -= lookVec.x * moveSpeed;
    location.x -= lookVec.z * moveSpeed;
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

-(void)calculateLookVec
{
    lookVec.x = sinf([self degToRad:rotation.y]);
    lookVec.z = cosf([self degToRad:rotation.y]);
    
    NSLog(@"Look vec %f,%f",lookVec.x,lookVec.y);
}

-(float)degToRad:(float) fAngDeg
{
    const float fDegToRad = 3.14159f * 2.0f / 360.0f;
    return fAngDeg * fDegToRad;
}

@end
