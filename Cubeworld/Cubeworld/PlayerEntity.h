//
//  PlayerEntity.h
//  Cubeworld
//
//  Created by Tom Jones on 09/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface PlayerEntity : Entity
{
    vec3 rotation;
    vec3 oldLocation;
    
    float moveSpeed;
    float lookSpeed;
}

-(vec3 *)playerRotation;

-(void)moveForward;
-(void)moveBackward;
-(void)moveRight;
-(void)moveLeft;
-(void)moveUp;
-(void)moveDown;


-(void)lookUp;
-(void)lookDown;
-(void)lookRight;
-(void)lookLeft;

-(void)unmove;
-(void)setOldLocation:(vec3 *)old;
@end
