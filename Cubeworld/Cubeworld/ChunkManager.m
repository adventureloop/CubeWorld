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
    NSDate *methodStart = [NSDate date];
    
    NSString *key = [NSString stringWithFormat:@"x:%f z:%f",x,z];
    Chunk *res = [chunkStore objectForKey:key];
    
    if(res == nil) {
        res = [generator chunkForX:x Z:z];  //Spends a ton of time in here, like seconds
        [chunkStore setValue:res forKey:key];
    }
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"\tDictionary and generator time %f",executionTime);
    
    return res;
}
@end
