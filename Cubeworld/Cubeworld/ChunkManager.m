//
//  ChunkManager.m
//  Cubeworld
//
//  Created by Tom Jones on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChunkManager.h"

@implementation ChunkManager
-(id)init
{
    if(self = [super init]) {
        chunkStore = [[NSMutableArray alloc]init];
        [chunkStore addObject:[[Chunk alloc]init]];
     }
    return self;
}

-(Chunk *)chunkForPoint:(vec3 *)point
{
    return [chunkStore lastObject];
}
@end
