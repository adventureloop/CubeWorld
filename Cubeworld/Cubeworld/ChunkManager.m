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
    }
    return self;
   
}

-(ChunkLowMem *)chunkForPoint:(vec3 *)point
{
    return nil;//[chunkStore lastObject];
}

-(ChunkLowMem *)chunkForX:(float)x Z:(float)z
{
    NSString *key = [NSString stringWithFormat:@"x:%f z:%f",x,z];
    ChunkLowMem *res = [chunkStore objectForKey:key];
    
    if(res == nil) {
        res = [generator chunkForX:x Z:z];  //Spends a ton of time in here, like seconds
        [chunkStore setValue:res forKey:key];
    }
    
    return res;
}
@end
