//
//  Generator.h
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"

/*!
 * @abstract Handles noise based generation of terrain for chunks.
 */
@interface Generator : NSObject
{
}

/*!
 * @discussion Returns the generated chunk for given x and z.
 */
-(ChunkLowMem *)chunkForX:(float)x Z:(float)z;

/*!
 * @discussion  Creates a noise based height map.
 * The alpha value effects the overall height of the chunk, the smaller, the closer to max chunk height
 * a value of 1 will build a chunk at max height
 *
 * Beta effects the variation within the chunk, the larger the value the lower the variation with in the
 * chunk. 1 is also not good in this situation.
 */
-(void)createHeightMap:(int[18][18])heightMap Alpha:(int)alpha Beta:(int)beta ForHeight:(int)height chunkX:(int)cx chunkZ:(int)cz;


-(ChunkLowMem *)islandBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)forestBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)grasslandBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)desertBiomeChunkForX:(float) cx Z:(float)cz;

-(ChunkLowMem *)tundraBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)taigaBiomeChunkForX:(float) cx Z:(float)cz;

/*!
 * @discussion Adds a random tree(from static list) to the chunk at given indexes
 */
-(void)addTreeToChunk:(ChunkLowMem *)chunk forX:(float)x Y:(float)y Z:(float)z;
@end
