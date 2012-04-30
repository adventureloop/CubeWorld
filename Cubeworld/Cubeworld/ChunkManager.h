//
//  ChunkManager.h
//  Cubeworld
//
//  Created by Tom Jones on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
#import "Generator.h"

/*!
 * @abstract Handles management over the loading and generation of chunks.
 * @discussion Manages the active chunks in memory, handles serialisation 
 * of chunks and loading from the generator. 
 */
@interface ChunkManager : NSObject
{
    NSMutableDictionary *chunkStore;
    Generator *generator;
    
    vec3 focusPoint;
}

/*!
 * @discussion Returns the chunk for the given x and y indexes.
 */
-(ChunkLowMem *)chunkForX:(float)x Z:(float)z;

/*!
 * @discussion Sets the focus point for the manager, culling happens around
 * this point.
 */
-(void)setFocusPoint:(vec3 *)point;

/*!
 * @discussion Calculates the distance between two vectors, used for calculating 
 * how far away chunks are from the focus.
 */
-(float)distanceBetweenA:(vec3 *)a B:(vec3 *)b;
+(ChunkManager *)sharedChunkManagerWithSeed:(NSString *)seed;
@end
