//
//  Entity.m
//  Cubeworld
//
//  Created by Tom Jones on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity
-(id)init
{
    if(self = [super init]) {
        resourceManager = [ResourceManager sharedResourceManager];
    }
    return self;
}

-(void)render {}
-(void)updateWithDelta:(NSTimeInterval)delta {}

-(BOOL)collidesWithPoint:(vec3 *)point
{
    return NO;
}

@end
