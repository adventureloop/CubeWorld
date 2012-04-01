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

    int heightMap[18][18];
    [self createHeightMap:heightMap Alpha:3 Beta:2 ForHeight:[tmp height] chunkX:cx chunkZ:cz];
    
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
                if(y < 55)
                    [tmp updateBlockType:BLOCK_WATER forX:x-1 Y:55 Z:z-1];
                else if(y == 56)
                    [tmp updateBlockType:BLOCK_SAND forX:x-1 Y:56 Z:z-1];
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
    NSLog(@"Generation time %f for (%.0f x,%.0f z)",executionTime,cx,cz);
    
    return tmp;
}

/*
 * The alpha value effects the overall height of the chunk, the smaller, the closer to max chunk height
 * a value of 1 will build a chunk at max height
 *
 * Beta effects the variation within the chunk, the larger the value the lower the variation with in the
 * chunk. 1 is also not good in this situation.
 */

-(void)createHeightMap:(int [18][18])heightMap Alpha:(int)alpha Beta:(int)beta ForHeight:(int)height chunkX:(int)cx chunkZ:(int)cz
{
    float baselimit = PerlinNoise2D((cx/10.0) + 0.2,(cz/10.0) + 0.2, 2, 2, 6);
    baselimit = (baselimit * height/alpha) + (height / 3);
    baselimit = (baselimit > 0) ? baselimit : -baselimit;
    
    float variation = baselimit / beta;
    
    for(int x = 1;x < 17;x++) 
        for(int z = 1;z < 17;z++) {
            float limit = PerlinNoise2D((cx+x/10.0) + 0.4,(cz+z/10.0) + 0.4, 2, 2, 6);
            limit = limit * variation;
            limit += baselimit;
            heightMap[x][z] = limit;
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
}

-(ChunkLowMem *)chunkForPoint:(vec3 *)point
{
    return nil;
}
@end
