//
//  Generator.h
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"

enum BIOMES_TYPES
{
    TUNDRA,
    TAIGA,
    DESERT,
    ISLAND,
    GRASSLAND,
    FOREST
};

/*!
 * @abstract Handles noise based generation of terrain for chunks.
 */
@interface Generator : NSObject
{
}

-(id)initWithSeed:(NSString *)seed;

/*!
 * @discussion Returns the generated chunk for given x and z.
 */
-(void)generateChunk:(ChunkLowMem *)chunk;

/*!
 * @discussion  Creates a noise based height map.
 */
-(void)createHeightMap:(int [18][18])heightMap ForHeight:(int)height chunkX:(int)cx chunkZ:(int)cz;


-(void)islandBiomeChunk:(ChunkLowMem *)chunk ForX:(float) cx Z:(float)cz;
-(void)forestBiomeChunk:(ChunkLowMem *)chunk ForX:(float) cx Z:(float)cz;
-(void)grasslandBiomeChunk:(ChunkLowMem *)chunk ForX:(float) cx Z:(float)cz;
-(void)desertBiomeChunk:(ChunkLowMem *)chunk ForX:(float) cx Z:(float)cz;

-(void)tundraBiomeChunk:(ChunkLowMem *)chunk ForX:(float) cx Z:(float)cz;
-(void)taigaBiomeChunk:(ChunkLowMem *)chunk ForX:(float) cx Z:(float)cz;
/*!
 * @discussion Adds a random tree(from static list) to the chunk at given indexes
 */
-(void)addTreeToChunk:(ChunkLowMem *)chunk forX:(float)x Y:(float)y Z:(float)z;

-(int)biomeForChunkX:(float)cx Z:(float)cz;
@end
