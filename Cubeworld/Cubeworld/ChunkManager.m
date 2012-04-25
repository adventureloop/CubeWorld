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
        chunkStore = [[NSMutableDictionary alloc]init];
        generator = [[Generator alloc]init];
        
        generationQueue = [[NSOperationQueue alloc]init];
        
        focusPoint.x = 0;
        focusPoint.z = 0;
        focusPoint.y = 0;
    }
    return self;
   
}

+(ChunkManager *)sharedChunkManager
{
    static ChunkManager *shared;
    @synchronized(self)
    {
        if (!shared)
            shared = [[ChunkManager alloc] init];
        return shared;
    }
}

-(ChunkLowMem *)chunkForX:(float)x Z:(float)z
{
    if([chunkStore count] > 80) {
        NSLog(@"\t\t\tCulling Chunk store, %lu chunks in memory",[chunkStore count]);
        
        NSMutableArray *removeList = [[NSMutableArray alloc]init ];
        
        for(id key in chunkStore) {
            ChunkLowMem *c = [chunkStore objectForKey:key];
            if([self distanceBetweenA:&focusPoint B:[c chunkLocation]] > 2)
                [removeList addObject:key];
        }
        
        for(id key in removeList)
            [chunkStore removeObjectForKey:key];
    }
    
    NSString *key = [NSString stringWithFormat:@"x:%f z:%f",x,z];
    ChunkLowMem *res = [chunkStore objectForKey:key];
    
    if(res == nil) {
        res = [[ChunkLowMem alloc]init];
        [res setChunkLocationForX:x Z:z];
        
        [chunkStore setValue:res forKey:key];
        
        NSInvocationOperation* theOp = [[[NSInvocationOperation alloc] initWithTarget:generator
                                                                             selector:@selector(generateChunk:) object:res] autorelease];
        
        [theOp start];
        //[generationQueue addOperation:theOp];
    }
    
    return res;
}

-(void)setFocusPoint:(vec3 *)point
{
    focusPoint.x = point->x;
    focusPoint.z = point->z;
    focusPoint.y = 0;
}

-(float)distanceBetweenA:(vec3 *)a B:(vec3 *)b
{
    return sqrtf(powf((a->x - b->x),2) + powf((a->z - b->z), 2));
}
@end
