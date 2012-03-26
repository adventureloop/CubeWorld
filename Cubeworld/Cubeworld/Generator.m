//
//  Generator.m
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Generator.h"
#import "BlockTypes.h"
#include <time.h>
#import "PerlinNoise.h"

@implementation Generator
-(id)init
{
    if(self = [super init]) {
        //srandom(time(NULL));
    }
    return self;
}

-(Chunk *)chunkForX:(float)x Z:(float)z
{
    Chunk *tmp = [[Chunk alloc] init];
    
    float limit = (random()%64) + 30;
    
//    for(int y = 0;y < 128;y++)
//        if(y > limit) {
//            for(int x = 0;x < 16;x++)
//                for(int z = 0;z < 16;z++)
//                    [tmp updateBlockType:BLOCK_AIR forX:x Y:y Z:z];
//            NSLog(@"%f",PerlinNoise3D(x+0.1, y+0.1, z+0.5, 2, 2, 6));
//            //limit = (random()%64) + 30;
//        }
    
    for(double x = 0;x < 16;x++) 
        for(double z = 0;z < 16;z++) {
         //   NSLog(@"%f",PerlinNoise3D(0.1, 0.1, 0.5, 2, 2, 6));
            limit = PerlinNoise3D(x/10.0,0.0,z/10.0, 2, 2, 6);
            limit = limit * 128;
            limit = (limit > 0) ? limit : -limit;
            for(double y = 0;y < 128;y++)
                if(y > limit) 
                    [tmp updateBlockType:BLOCK_AIR forX:x Y:y Z:z];
        }
    
    
    return tmp;
}

-(Chunk *)chunkForPoint:(vec3 *)point
{
    return nil;
}
@end
