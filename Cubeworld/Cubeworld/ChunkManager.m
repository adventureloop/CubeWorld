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
        
        
        for(int y = 0;y < 128;y++)
            if(y > 5) 
                for(int x = 0;x < 16;x++)
                    for(int z = 0;z < 16;z++)
                        [[chunkStore lastObject] updateBlockType:BLOCK_AIR forX:x Y:y Z:z];
                    
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
