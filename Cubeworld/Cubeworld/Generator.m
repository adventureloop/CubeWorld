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
    
    float baselimit = PerlinNoise2D((x/10.0) + 0.4,(z/10.0) + 0.4, 2, 2, 6);
    baselimit = baselimit * 128;
    baselimit = (baselimit > 0) ? baselimit : -baselimit;
    
    float variation = baselimit / 5.0;
    
    for(double x = 0;x < 16;x++) 
        for(double z = 0;z < 16;z++) {
            float limit = PerlinNoise2D((x/10.0) + 0.4,(z/10.0) + 0.4, 2, 2, 6);
            limit = limit * variation;
            for(double y = 0;y < 128;y++)
                if(y > baselimit+limit) 
                    [tmp updateBlockType:BLOCK_AIR forX:x Y:y Z:z];
        }
    
    return tmp;
}

-(Chunk *)chunkForPoint:(vec3 *)point
{
    return nil;
}
@end
