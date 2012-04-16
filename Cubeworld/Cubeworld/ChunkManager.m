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

-(ChunkLowMem *)chunkForX:(float)x Z:(float)z
{
    if([chunkStore count] > 25) {
        [chunkStore removeAllObjects];
    }
    
    
    NSString *key = [NSString stringWithFormat:@"x:%f z:%f",x,z];
    ChunkLowMem *res = [chunkStore objectForKey:key];
    
    if(res == nil) {
        NSDate *methodStart = [NSDate date];

        res = [generator chunkForX:x Z:z]; 
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        NSLog(@"Generation time %f for (%.0f x,%.0f z)",executionTime,x,z);
        
        [chunkStore setValue:res forKey:key];
    }
    
    return res;
}


@end
