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
    float noise = PerlinNoise2D(cx+0.1, cz+0.1, 2, 2, 6);
    
    if(noise > 0.25)
        return [self taigaBiomeChunkForX:cx Z:cz];
    if(noise > 0.18)
        return [self tundraBiomeChunkForX:cx Z:cz];
    if(noise > 0.0)
        return [self forestBiomeChunkForX:cx Z:cz];
    if(noise > -0.1)
        return [self grasslandBiomeChunkForX:cx Z:cz];
    if(noise > -0.2)
        return [self islandBiomeChunkForX:cx Z:cz];
    if(noise > -1.0)
        return [self desertBiomeChunkForX:cx Z:cz];
    return [self grasslandBiomeChunkForX:cx Z:cz];
}

-(ChunkLowMem *)islandBiomeChunkForX:(float)cx Z:(float)cz
{
    NSLog(@"\tIsland Biome");
    
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
                if(y < WATER_LEVEL)
                    if(y < WATER_LEVEL - 5)
                        [tmp updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [tmp updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [tmp updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y == WATER_LEVEL+1)
                    [tmp updateBlockType:BLOCK_SAND forX:x-1 Y:WATER_LEVEL+1 Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else if(y > 70)
                    [tmp updateBlockType:BLOCK_DIRT forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_GRASS forX:x-1 Y:y Z:z-1];
            }
        }
    return tmp;
}

-(ChunkLowMem *)forestBiomeChunkForX:(float)cx Z:(float)cz
{
    NSLog(@"\tForest Biome");
    
    ChunkLowMem *tmp = [[[ChunkLowMem alloc] init] autorelease];
    
    int heightMap[18][18];
    [self createHeightMap:heightMap Alpha:5 Beta:10 ForHeight:[tmp height] chunkX:cx chunkZ:cz];
    
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
                if(y < WATER_LEVEL)
                    if(y < WATER_LEVEL - 5)
                        [tmp updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [tmp updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [tmp updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y == WATER_LEVEL+1)
                    [tmp updateBlockType:BLOCK_SAND forX:x-1 Y:WATER_LEVEL+1 Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else if(y > 70)
                    [tmp updateBlockType:BLOCK_DIRT forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_GRASS forX:x-1 Y:y Z:z-1];
            }
        }
    for(int x = 1; x < 17;x++)
        for(int z = 1; z < 17;z++)
            if(heightMap[x][z] > 50  && (x%(6 + rand()%5)) == 0)
                [self addTreeToChunk:tmp forX:x Y:heightMap[x][z] Z:z];
    
    return tmp;
}

-(ChunkLowMem *)grasslandBiomeChunkForX:(float)cx Z:(float)cz
{
    NSLog(@"\tGrassland Biome");
    
    ChunkLowMem *tmp = [[[ChunkLowMem alloc] init] autorelease];
    
    int heightMap[18][18];
    [self createHeightMap:heightMap Alpha:5 Beta:10 ForHeight:[tmp height] chunkX:cx chunkZ:cz];
    
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
                if(y < WATER_LEVEL)
                    if(y < WATER_LEVEL - 5)
                        [tmp updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [tmp updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [tmp updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y == WATER_LEVEL+1)
                    [tmp updateBlockType:BLOCK_SAND forX:x-1 Y:WATER_LEVEL+1 Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else if(y > 70)
                    [tmp updateBlockType:BLOCK_DIRT forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_GRASS forX:x-1 Y:y Z:z-1];
            }
        }
    
    for(int x = 1; x < 17;x++)
        for(int z = 1; z < 17;z++)
            if(heightMap[x][z] > 50  && (x%(6 + rand()%10)) == 0)
                [self addTreeToChunk:tmp forX:x Y:heightMap[x][z] Z:z];
    
    return tmp;
}

-(ChunkLowMem *)desertBiomeChunkForX:(float)cx Z:(float)cz
{
    NSLog(@"\tDesert Biome");
    
    ChunkLowMem *tmp = [[[ChunkLowMem alloc] init] autorelease];
    
    int heightMap[18][18];
    [self createHeightMap:heightMap Alpha:3 Beta:4 ForHeight:[tmp height] chunkX:cx chunkZ:cz];
    
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
                if(y < WATER_LEVEL)
                    if(y < WATER_LEVEL - 5)
                        [tmp updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [tmp updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [tmp updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_SAND forX:x-1 Y:y Z:z-1];
            }
        }
    return tmp;
}

-(ChunkLowMem *)tundraBiomeChunkForX:(float)cx Z:(float)cz
{
    NSLog(@"\tTundra Biome");
    
    ChunkLowMem *tmp = [[[ChunkLowMem alloc] init] autorelease];
    
    int heightMap[18][18];
    [self createHeightMap:heightMap Alpha:5 Beta:10 ForHeight:[tmp height] chunkX:cx chunkZ:cz];
    
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
                if(y < WATER_LEVEL)
                    if(y < WATER_LEVEL - 5)
                        [tmp updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [tmp updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [tmp updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_SNOW forX:x-1 Y:y Z:z-1];
            }
        }
    return tmp;
}

-(ChunkLowMem *)taigaBiomeChunkForX:(float)cx Z:(float)cz
{
    NSLog(@"\tTaiga Biome");
    
    ChunkLowMem *tmp = [[[ChunkLowMem alloc] init] autorelease];
    
    int heightMap[18][18];
    [self createHeightMap:heightMap Alpha:5 Beta:6 ForHeight:[tmp height] chunkX:cx chunkZ:cz];
    
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
                if(y < WATER_LEVEL)
                    if(y < WATER_LEVEL - 5)
                        [tmp updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [tmp updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [tmp updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y > 80)
                    [tmp updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else
                    [tmp updateBlockType:BLOCK_SNOW forX:x-1 Y:y Z:z-1];
            }
        }
    
    for(int x = 1; x < 17;x++)
        for(int z = 1; z < 17;z++)
            if(heightMap[x][z] > 50  && (x%(4 + rand()%2)) == 0)
                [self addTreeToChunk:tmp forX:x Y:heightMap[x][z] Z:z];
    return tmp;
}


-(void)addTreeToChunk:(ChunkLowMem *)chunk forX:(float)x Y:(float)y Z:(float)z
{
    [chunk updateBlockType:BLOCK_WOOD forX:x Y:y++ Z:z];
    [chunk updateBlockType:BLOCK_WOOD forX:x Y:y++ Z:z];
    [chunk updateBlockType:BLOCK_WOOD forX:x Y:y++ Z:z];
    
    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y Z:z-1];
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z+1];
    [chunk updateBlockType:BLOCK_LEAF forX:x+1 Y:y Z:z+1];

    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y Z:z];
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z];
    [chunk updateBlockType:BLOCK_LEAF forX:x+1 Y:y Z:z];

    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y Z:z-1];
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z-1];
    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y++ Z:z+1];
    
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z];
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
    float baselimit = PerlinNoise2D((cx/10.0) + 0.2,(cz/10.0) + 0.2, alpha, beta, 6);
    
    baselimit = (baselimit * height/alpha) + (height / 3);
    baselimit = (baselimit > 0) ? baselimit : -baselimit;   //Make the reference level positive
    
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
        
        limit = limit * variation;
        limit += baselimit;
        heightMap[17][z] = limit;
    }
}
@end
