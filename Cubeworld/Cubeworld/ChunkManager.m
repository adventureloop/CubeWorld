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
        chunkStore = [[NSMutableDictionary alloc]init];
        generator = [[Generator alloc]init];
    }
    return self;
   
}

-(Chunk *)chunkForPoint:(vec3 *)point
{
    return nil;//[chunkStore lastObject];
}

-(Chunk *)chunkForX:(float)x Z:(float)z
{
    NSString *key = [NSString stringWithFormat:@"%d:%d",x,z];
    Chunk *res = [chunkStore objectForKey:key];
    
    if(res == nil) {
        res = [generator chunkForX:x Z:z];
        [chunkStore setValue:res forKey:key];
    }
    return res;
}
@end
