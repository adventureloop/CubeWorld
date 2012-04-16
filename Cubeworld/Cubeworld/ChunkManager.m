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
        
        focusPoint.x = 0;
        focusPoint.z = 0;
        focusPoint.y = 0;
    }
    return self;
   
}

-(ChunkLowMem *)chunkForX:(float)x Z:(float)z
{
    if([chunkStore count] > 30) {
        for(id key in chunkStore) {
            ChunkLowMem *c = [chunkStore objectForKey:key];
            if([self distanceBetweenA:&focusPoint B:[c chunkLocation]] > 2)
                [chunkStore removeObjectForKey:key];
        }
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
        
        [res setReadyToRender:YES];
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
