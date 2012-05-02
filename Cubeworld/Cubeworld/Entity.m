//
//  Entity.m
//  Cubeworld
//
//  Created by Tom Jones on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity

-(id)initWithChunk:(ChunkLowMem *)achunk
{
    if(self = [super init]) {
        resourceManager = [ResourceManager sharedResourceManager];
        chunk = achunk;
    }
    return self;
}

-(void)render {}
-(void)updateWithDelta:(NSTimeInterval)delta {}

-(BOOL)collidesWithPoint:(vec3 *)point
{
    return NO;
}

-(void)setLocation:(vec3 *)newLocation
{
    location.x = newLocation->x;
    location.y = newLocation->y;
    location.z = newLocation->z;
}

-(vec3 *)entityLocation
{
    return &location;
}
@end
