//
//  Generator.h
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"

@interface Generator : NSObject
{
}

-(ChunkLowMem *)chunkForX:(float)x Z:(float)z;

-(void)createHeightMap:(int [18][18])heightMap Alpha:(int)alpha Beta:(int)beta ForHeight:(int)height chunkX:(int)cx chunkZ:(int)cz;


-(ChunkLowMem *)islandBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)forestBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)grasslandBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)desertBiomeChunkForX:(float) cx Z:(float)cz;

-(ChunkLowMem *)tundraBiomeChunkForX:(float) cx Z:(float)cz;
-(ChunkLowMem *)taigaBiomeChunkForX:(float) cx Z:(float)cz;

-(void)addTreeToChunk:(ChunkLowMem *)chunk forX:(float)x Y:(float)y Z:(float)z;
@end
