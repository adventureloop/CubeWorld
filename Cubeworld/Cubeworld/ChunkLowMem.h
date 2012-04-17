//
//  Chunk.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OctnodeLowMem.h"

/*!
 * @abstract Low Memory implementation of Chunk
 * @discussion The Original Chunk implementation suffered performance issues to the massive number
 * of elements it contain. This ReImplementation uses a memory manager approach to handle the memory
 * to store the voxeldata. This allows the use of much less data and increases the speed of rendering.
 */
@interface ChunkLowMem : NSObject
{
    GLuint vertexBufferObject;
    GLuint vertexArrayObject;
    GLuint indexBufferObject;
    NSMutableArray *nodes;
    
    float *vertexData;
    unsigned int *indexArray;
    int *tmpIndexArray;
    
    int voxelCounter;
    int maxVoxels;
    
    int trees;
    int treeHeight;
    float nodeSize;
    float chunkWidth;
    
    BOOL needsUpdate;
    
    vec3 localOrigin;
    vec3 worldOrigin;
    
    vec3 chunkLocation;
}
/*!
 * @discussion Creates a new chunk with the specified number of trees 
 * matching the tree height parameter.
 */
-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight;

/*!
 * @discussion Renders all the voxels inside the chunk. Rendering will
 * block when updates are required to the memory mapped into the graphics
 * card. Rendering will only happen once readyToRender has been called on
 * the chunk.
 */
-(void)render;

/*!
 * @discussion Calculates the number of voxels inside the entire octree.
 */-(int)voxelsToRender;

/*!
 * @abstract Memory management for voxelData Structures.
 * @discussion This method provides an initial meta data management for the
 * rendering system. This method returns a pointer to a valid voxelData struct
 * and fills the offset index. The offest index represents where in the giant 
 * array of memory the voxel data struct is. This is used in elemented render
 * by the octree.
 */
-(voxelData *)getRenderMetaData:(int *)offset;

/*!
 * @discussion Whenever a voxel needs to change the data around it, the voxels
 * data struct needs to be updated. The previously provided pointer can become]
 * invalid in a realloc.
 */
-(voxelData *)updateRenderMetaData:(int)offset;

/*!
 * @discussion Returns the chunks position in world space.
 */

-(vec3 *)worldOrigin;

/*!
 * @discussion Update the position of the chunk in world space.
 */
-(void)setWorldOrigin:(vec3 *)newOrigin;

/*!
 * @discussion Updates the memory mapped into the graphics card by recursively
 * moving through the octree network.
 */
-(void)update;

/*!
 * @discussion Update the block type for the voxel that intersects with the 
 * position given by point.
 */-(BOOL)updateBlockType:(int) type forPoint:(vec3 *)point;

/*!
 * @discussion Update the block type for the voxel that matches up with the
 * index given. Calculates the position vector for the index given, then does
 * a updateBlockType: forPoint to do the actual update.
 */
-(void)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z;

/*!
 * @discussion Checks whether the chunk intersects with the given point
 */-(bool)collidesWithPoint:(vec3 *)point;

/*!
 * @discussion Returns the point for the given x y z index
 */
-(void)point:(vec3 *)point forX:(float)x Y:(float)y Z:(float)z;

/*!
 * @discussion Returns the block type for the voxel at index.
 */
-(int)blockTypeForX:(float)x Y:(float)y Z:(float)z;

/*!
 * @discussion Calculates the width in x and z for the chunk in world space
 * sizes.
 */
-(float)chunkDimensions;

/*!
 * @discussion Calculcates the height of the chunk in voxels.
 */
-(int)height;

/*!
 * @discussion Updates every voxel in the chunk to the given colour
 */
-(void)updateAllToColour:(colour *)colour;

/*!
 * @discussion Set the chunk world space index.
 */ 
-(void)setChunkLocationForX:(float)x Z:(float)z;

/*!
 * @discussion Returns the chunks index location in world space.
 */
-(vec3 *)chunkLocation;
@property BOOL readyToRender;
@end
