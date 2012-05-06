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
#import "TreeEntity.h"
#import "YakEntity.h"

#include <time.h>

@implementation Generator

int BIOME_ALPHA[] =
{
    5,
    5,
    3,
    3,
    5,
    5
};

int BIOME_BETA[] =
{
    10,
    6,
    4,
    2,
    10,
    10
};


-(id)init
{
    if(self = [super init]) {
        srandom(time(NULL));
    }
    return self;
}

-(id)initWithSeed:(NSString *)seed
{
    if(self = [super init]) {
        if([seed length] < 1)
            srandom(time(NULL));
        else 
            srandom([seed hash]);
    }
    return self;
}

-(void)generateChunk:(ChunkLowMem *)chunk;
{
    vec3 *chunkLoc = [chunk chunkLocation];
    float cx,cz;
    cx = chunkLoc->x;
    cz = chunkLoc->z;
    
    switch ([self biomeForChunkX:cx Z:cz]) {
        case TUNDRA:
            [self tundraBiomeChunk:chunk ForX:cx Z:cz];
            break;
        case TAIGA:
            [self taigaBiomeChunk:chunk ForX:cx Z:cz];
            break;
        case FOREST:
            [self forestBiomeChunk:chunk ForX:cx Z:cz];
            break;
        case GRASSLAND:
            [self grasslandBiomeChunk:chunk ForX:cx Z:cz];
            break;
        case ISLAND:
            [self islandBiomeChunk:chunk ForX:cx Z:cz];
            break;
        case DESERT:
            [self desertBiomeChunk:chunk ForX:cx Z:cz];
            break;
        default:
            [self grasslandBiomeChunk:chunk ForX:cx Z:cz];
            break;
    }

    [chunk setReadyToRender:YES];
}

-(void)islandBiomeChunk:(ChunkLowMem *)chunk ForX:(float)cx Z:(float)cz
{
    NSLog(@"\tIsland Biome in chunk %f,%f",cx,cz);
    
    int heightMap[18][18];
    [self createHeightMap:heightMap ForHeight:[chunk height] chunkX:cx chunkZ:cz];
    
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
                        [ chunk updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [ chunk updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [ chunk updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y == WATER_LEVEL+1)
                    [ chunk updateBlockType:BLOCK_SAND forX:x-1 Y:WATER_LEVEL+1 Z:z-1];
                else if(y > 80)
                    [ chunk updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else if(y > 70)
                    [ chunk updateBlockType:BLOCK_DIRT forX:x-1 Y:y Z:z-1];
                else
                    [ chunk updateBlockType:BLOCK_GRASS forX:x-1 Y:y Z:z-1];
            }
        }
    [chunk setReadyToRender:YES];
}

-(void)forestBiomeChunk:(ChunkLowMem *)chunk ForX:(float)cx Z:(float)cz
{
    NSLog(@"\tForest Biome in chunk %f,%f",cx,cz);
    int heightMap[18][18];

    [self grasslandBiomeChunk:chunk ForX:cx Z:cz];

    [self createHeightMap:heightMap ForHeight:[chunk height] chunkX:cx chunkZ:cz];
    
    for(int x = 2; x < 16;x++)
        for(int z = 2; z < 16;z++)
            if(heightMap[x][z] > WATER_LEVEL+2  && (x%(6 + rand()%5)) == 0)
                [self addTreeToChunk: chunk forX:x Y:heightMap[x][z] Z:z];
    [chunk setReadyToRender:YES];
}

-(void)grasslandBiomeChunk:(ChunkLowMem *)chunk ForX:(float)cx Z:(float)cz
{
    NSLog(@"\tGrassland Biome in chunk %f,%f",cx,cz);
    
    int heightMap[18][18];
    [self createHeightMap:heightMap ForHeight:[chunk height] chunkX:cx chunkZ:cz];
    
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
                        [ chunk updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [ chunk updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [ chunk updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y == WATER_LEVEL+1)
                    [ chunk updateBlockType:BLOCK_SAND forX:x-1 Y:WATER_LEVEL+1 Z:z-1];
                else if(y > 80)
                    [ chunk updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else if(y > 70)
                    [ chunk updateBlockType:BLOCK_DIRT forX:x-1 Y:y Z:z-1];
                else
                    [ chunk updateBlockType:BLOCK_GRASS forX:x-1 Y:y Z:z-1];
            }
        }
    
    for(int x = 2; x < 16;x++)
        for(int z = 2; z < 16;z++)
            if(heightMap[x][z] > WATER_LEVEL+3  && (x%(6 + rand()%10)) == 0)
                [self addTreeToChunk: chunk forX:x Y:heightMap[x][z] Z:z];
    
    [chunk addEntity:[[YakEntity alloc]init]];
     
    [chunk setReadyToRender:YES];
}

-(void)desertBiomeChunk:(ChunkLowMem *)chunk ForX:(float)cx Z:(float)cz
{
    NSLog(@"\tDesert Biome in chunk %f,%f",cx,cz);

    int heightMap[18][18];
    [self createHeightMap:heightMap ForHeight:[chunk height] chunkX:cx chunkZ:cz];
    
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
                        [ chunk updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [ chunk updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [ chunk updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y > 80)
                    [ chunk updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else
                    [ chunk updateBlockType:BLOCK_SAND forX:x-1 Y:y Z:z-1];
            }
        }
    [chunk setReadyToRender:YES];
}

-(void)tundraBiomeChunk:(ChunkLowMem *)chunk ForX:(float)cx Z:(float)cz
{
    NSLog(@"\tTundra Biome in chunk %f,%f",cx,cz);

    int heightMap[18][18];
    [self createHeightMap:heightMap ForHeight:[chunk height] chunkX:cx chunkZ:cz];
    
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
                        [ chunk updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [ chunk updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [ chunk updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y > 80)
                    [ chunk updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else
                    [ chunk updateBlockType:BLOCK_SNOW forX:x-1 Y:y Z:z-1];
            }
        }
    [chunk setReadyToRender:YES];
}

-(void)taigaBiomeChunk:(ChunkLowMem *)chunk ForX:(float)cx Z:(float)cz
{
    NSLog(@"\tTaiga Biome in chunk %f,%f",cx,cz);
    
    int heightMap[18][18];
    [self createHeightMap:heightMap ForHeight:[chunk height] chunkX:cx chunkZ:cz];
    
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
                        [ chunk updateBlockType:BLOCK_WATER_DEEP forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else if(y < WATER_LEVEL -3)
                        [ chunk updateBlockType:BLOCK_WATER_MID forX:x-1 Y:WATER_LEVEL Z:z-1];
                    else 
                        [ chunk updateBlockType:BLOCK_WATER_SHALLOW forX:x-1 Y:WATER_LEVEL Z:z-1];
                else if(y > 80)
                    [ chunk updateBlockType:BLOCK_STONE forX:x-1 Y:y Z:z-1];
                else
                    [ chunk updateBlockType:BLOCK_SNOW forX:x-1 Y:y Z:z-1];
            }
        }
    
    for(int x = 2; x < 16;x++)
        for(int z = 2; z < 16;z++)
            if(heightMap[x][z] > WATER_LEVEL+3  && (x%(4 + rand()%2)) == 0)
                [self addTreeToChunk: chunk forX:x Y:heightMap[x][z] Z:z];
    [chunk setReadyToRender:YES];
}


-(void)addTreeToChunk:(ChunkLowMem *)chunk forX:(float)x Y:(float)y Z:(float)z
{
    vec3 location;
    location.x = x;
    location.y = y;
    location.z = z;
    
    TreeEntity *tree = [[TreeEntity alloc]init];
    [tree setLocation:&location];
    
    [chunk addEntity:tree];
    
    [tree grow];
    
}

/*
 * The alpha value effects the overall height of the chunk, the smaller, the closer to max chunk height
 * a value of 1 will build a chunk at max height
 *
 * Beta effects the variation within the chunk, the larger the value the lower the variation with in the
 * chunk. 1 is also not good in this situation.
 */
-(void)createHeightMap:(int [18][18])heightMap ForHeight:(int)height chunkX:(int)cx chunkZ:(int)cz
{   
    float baselimit;
    float variation;
    
    [self calculateBaseLimit:&baselimit Varitation:&variation ForChunkX:cx Z:cz Height:height];
    
    for(int x = 1;x < 17;x++) 
        for(int z = 1;z < 17;z++) {
            float xval = (cx*16 + x)/10.0;
            float zval = (cz*16 + z)/10.0;
            float limit = PerlinNoise2D(xval,zval, 2, 2, 6);
            limit = limit * variation;
            limit += baselimit;
            heightMap[x][z] = limit;
        }
    
    //Calculate the heights for the chunk -1x
    [self calculateBaseLimit:&baselimit Varitation:&variation ForChunkX:cx-1 Z:cz Height:height];

    for(int x = 0;x < 18;x++) {
        float xval = ((cx - 1)*16 + x)/10.0;
        float zval = (cz*16 + 16)/10.0;
        float limit = PerlinNoise2D(xval,zval, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[x][0] = limit;
    }
    
    //Calculate the heights for the chunk + 1 x
    [self calculateBaseLimit:&baselimit Varitation:&variation ForChunkX:cx+1 Z:cz Height:height];
    
    for(int x = 0;x < 18;x++) {
        float xval = ((cx + 1)*16 + x)/10.0;
        float zval = (cz*16 + 1)/10.0;
        float limit = PerlinNoise2D(xval,zval, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[x][17] = limit;
    }
    
    [self calculateBaseLimit:&baselimit Varitation:&variation ForChunkX:cx Z:cz-1 Height:height];
    
    for(int z = 0;z < 18;z++){
        float xval = (cx*16 + 16)/10.0;
        float zval = ((cz - 1) *16 + z)/10.0;
        float limit = PerlinNoise2D(xval,zval, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[0][z] = limit;
    }
    
    [self calculateBaseLimit:&baselimit Varitation:&variation ForChunkX:cx Z:cz+1 Height:height];
    
    for(int z = 0;z < 18;z++){
        float xval = (cx*16 + 1)/10.0;
        float zval = ((cz + 1) *16 + z)/10.0;
        float limit = PerlinNoise2D(xval,zval, 2, 2, 6);
        limit = limit * variation;
        limit += baselimit;
        heightMap[17][z] = limit;
    }
}

-(void)calculateBaseLimit:(float *)baselimit Varitation:(float *)variation ForChunkX:(float)cx Z:(float)cz Height:(float)height
{
    int biome = [self biomeForChunkX:cx Z:cz];
    float alpha = BIOME_ALPHA[biome];
    float beta = BIOME_BETA[biome];
    
    *baselimit = (float)PerlinNoise2D((cx/10.0) + 0.2,(cz/10.0) + 0.2, alpha, beta, 6);
    
    *baselimit = (*baselimit * height/alpha) + (height / 3.0);
    *baselimit = (float)(*baselimit > 0) ? *baselimit : -*baselimit;   //Make the reference level positive
    
    *variation = *baselimit / beta;
}

-(int)biomeForChunkX:(float)cx Z:(float)cz
{
    float noise = PerlinNoise2D(cx+0.1, cz+0.1, 2, 2, 6);
    
    if(noise > 0.25)
        return TUNDRA;
    else if(noise > 0.18)
        return TAIGA;
    else if(noise > 0.0)
        return FOREST;
    else if(noise > -0.1)
        return GRASSLAND;
    else if(noise > -0.2)
        return ISLAND;
    else if(noise > -1.0)
        return DESERT;
    else 
        return GRASSLAND;
}
@end
