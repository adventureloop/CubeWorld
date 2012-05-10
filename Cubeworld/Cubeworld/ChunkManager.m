//
//  ChunkManager.m
//  Cubeworld
//
//  Created by Tom Jones on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ChunkManager.h"

@implementation ChunkManager
@synthesize serialize;
-(id)initWithSeed:(NSString *)seed worldName:(NSString *)worldName
{
    if(self = [super init]) {
        generator = [[Generator alloc]initWithSeed:seed];
        resourceManager = [ResourceManager sharedResourceManager];
        chunkStore = [[NSMutableDictionary alloc]init];
        
        focusPoint.x = 0;
        focusPoint.z = 0;
        focusPoint.y = 0;
        
        serialize = YES;
    }
    return self;
}

+(ChunkManager *)sharedChunkManagerWithSeed:(NSString *)seed worldName:(NSString *)worldName
{
    static ChunkManager *shared;
    @synchronized(self)
    {
        if (!shared)
            shared = [[ChunkManager alloc] initWithSeed:(NSString *)seed worldName:(NSString *)worldName];
        return shared;
    }
}

-(ChunkLowMem *)chunkForX:(float)x Z:(float)z
{
    if([chunkStore count] > 64) {
        NSLog(@"\t\t\tCulling Chunk store, %lu chunks in memory",[chunkStore count]);
        
        NSMutableArray *removeList = [[NSMutableArray alloc]init ];
        
        for(id key in chunkStore) {
            ChunkLowMem *c = [chunkStore objectForKey:key];
            if([self distanceBetweenA:&focusPoint B:[c chunkLocation]] > 2) {
                [removeList addObject:key];
            }
        }
        
        for(id key in removeList) {
            if(serialize) {
                ChunkLowMem *c = [chunkStore objectForKey:key];
                [resourceManager storeChunk:c];
            }
            [chunkStore removeObjectForKey:key];
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"x%dz%d",(int)x,(int)z];
    ChunkLowMem *res;
    res = [chunkStore objectForKey:key];
    
    if(res == nil && [resourceManager chunkExistsForString:key]) {
        NSLog(@"Getting chunk from disk");
        res = [resourceManager getChunkForXZ:key];
        
        [chunkStore setValue:res forKey:key];   
        
        [res setChunkLocationForX:x Z:z];
    }
    
    if(res == nil) {
        res = [[ChunkLowMem alloc]init];
        [res setChunkLocationForX:x Z:z];
        
        [chunkStore setValue:res forKey:key];   
        
        //[generator generateChunk:res];
        [generator performSelectorInBackground:@selector(generateChunk:) withObject:res];
    }
    return res;
}

-(void)storeAllChunks
{
    NSLog(@"Saving all active chunks");
    for(id key in chunkStore)
        [resourceManager storeChunk:[chunkStore objectForKey:key]];
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
