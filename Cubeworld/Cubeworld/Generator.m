//
//  Generator.m
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Generator.h"
#include "BlockTypes.h"
#import "PerlinNoise.h"

#include <time.h>

@implementation Generator
-(id)init
{
    if(self = [super init]) {
        //srandom(time(NULL));
    }
    return self;
}

-(ChunkLowMem *)chunkForX:(float)cx Z:(float)cz
{
    NSDate *methodStart = [NSDate date];
    
    ChunkLowMem *tmp = [[[ChunkLowMem alloc] init] autorelease];

    int blocksChanged = 0;
    
    int height = [tmp height];
    
    float baselimit = PerlinNoise2D((cx/10.0) + 0.2,(cz/10.0) + 0.2, 2, 2, 6);
    baselimit = (baselimit * height/2) + height / 3;
    baselimit = (baselimit > 0) ? baselimit : -baselimit;
    
    float variation = baselimit / 3.0;
    
    int heightMap[18][18];
    
    memset(heightMap, 0, sizeof(heightMap));
    
    for(int x = 1;x < 17;x++) 
        for(int z = 1;z < 17;z++) {
            float limit = PerlinNoise2D((cx+x/10.0) + 0.4,(cz+z/10.0) + 0.4, 2, 2, 6);
            limit = limit * variation;
            limit += baselimit;
            heightMap[x][z] = limit;
         //   [tmp updateBlockType:BLOCK_SOLID forX:x Y:limit Z:z];
           // blocksChanged++;
        }
    
    //Find edge heights
    for(int x = 0;x < 18;x++) {
        float limit = PerlinNoise2D(((cx-1)+x/10.0) + 0.4,(cz/10.0) + 0.4, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[x][0] = limit;
        
        limit = PerlinNoise2D(((cx-1)+x/10.0) + 0.4,(cz+17/10.0) + 0.4, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[x][17] = limit;
    }
    
    for(int z = 0;z < 18;z++){
        float limit = PerlinNoise2D((cx/10.0) + 0.4,((cz+1)+z/10.0) + 0.4, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[0][z] = limit;
        
        limit = PerlinNoise2D((cx+17/10.0) + 0.4,((cz-1)+z/10.0) + 0.4, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[17][z] = 0;
    }
    
    
    for(int x = 1;x < 17;x++)
        for(int z = 1;z < 17; z++) {
            double y = heightMap[x][z];
            double min = y;
            
            min = (min < heightMap[x-1][z-1]) ? min : heightMap[x-1][z-1];
            min = (min < heightMap[x-1][z]) ? min : heightMap[x-1][z];
            min = (min < heightMap[x-1][z+1]) ? min : heightMap[x-1][z+1];
            
            min = (min < heightMap[x+1][z-1]) ? min : heightMap[x+1][z-1];
            min = (min < heightMap[x+1][z]) ? min : heightMap[x+1][z];
            min = (min < heightMap[x+1][z+1]) ? min : heightMap[x+1][z+1];
            
            min = (min < heightMap[x][z-1]) ? min : heightMap[x][z-1];
            min = (min < heightMap[x][z+1]) ? min : heightMap[x][z+1];
            
            for(double y = heightMap[x][z];y >= min;y--) {
                if(y < 64)
                    [tmp updateBlockType:BLOCK_WATER forX:x-1 Y:64 Z:z-1];
                else if(y == 65)
                    [tmp updateBlockType:BLOCK_SAND forX:x-1 Y:65 Z:z-1];
                else if(y > 90)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_DIRT forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_GRASS forX:x-1 Y:y Z:z-1];
                
            }
            
        }
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"Generation time %f for %d changes (%.0f x,%.0f z)",executionTime,blocksChanged,cx,cz);
    
    return tmp;
}

-(ChunkLowMem *)chunkForPoint:(vec3 *)point
{
    return nil;
}
@end
