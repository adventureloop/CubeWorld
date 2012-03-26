//
//  ChunkManager.m
//  Cubeworld
//
//  Created by Tom Jones on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ChunkManager.h"
#import "BlockTypes.h"

@implementation ChunkManager
-(id)init
{
    if(self = [super init]) {
        chunkStore = [[NSMutableArray alloc]init];
        [chunkStore addObject:[[Chunk alloc]init]];
      
        
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:0 Y:0 Z:0];
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:1 Y:0 Z:0];
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:0 Y:0 Z:1];
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:1 Y:0 Z:1];
        
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:0 Y:1 Z:0];
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:1 Y:1 Z:0];
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:0 Y:1 Z:1];
        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:1 Y:1 Z:1];
        
     }
    return self;

   }

-(Chunk *)chunkForPoint:(vec3 *)point
{
    return [chunkStore lastObject];
}

-(Chunk *)chunkForX:(float)x Z:(float)z
{
    return [chunkStore lastObject];
}
@end
