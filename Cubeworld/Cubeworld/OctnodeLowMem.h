//
//  Octnode.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Structures.h"
#import "ChunkLowMem.h"

/*!
 * @abstract Low memory compilant implementation of Octnode.
 * @discussion Octnode handles the creation of an octree based of the height parameter 
 * given. The tree will build down until a height of zero, height zero nodes act as voxels.
 * Most functions are recursive working on the whole tree. Memory access and update operations
 * of the octree rely on the Memory manager in the ChunkLowMem.
 */
@interface OctnodeLowMem : NSObject
{
    NSMutableArray *nodes;
    
    vec3 origin;
    colour colour;
    float size;
    int height;
    
    voxelData *voxelPtr;
    int indexOffset;
    id *datasource;
    
    int blockType;
}
/*!
 * @discussion Creates an octree of given height, decreasing the height until the zero height tree 
 * is created. Memory for the voxels in the tree is divided up at each stage, until the zero tree
 * has a pointer to a single voxelData structure. New origins are created at each stage and the size
 * is decreased each time.
 */
-(id)initWithTreeHeight:(unsigned int)nodeHeight nodeSize:(float)nodeSize orign:(vec3 *)nodeOrigin dataSource:(id *)ndatasource;

/*!
 * @discussion Creates the subnodes in the octree.
 */
-(void)createSubnodes;

/*!
 * @discussion Retreive an active memory pointer and write voxel data to it.
 */
-(void)addVoxelData;

/*!
 * @discussion Calculates the new orgin given a scale function and an offset'ing vector
 */
-(void)calculateNewOrigin:(vec3 *)v1 OldOrigin:(vec3 *)v2 offsetVec:(vec3 *)offvec scale:(float) scale;

/*!
 * @discussion Recursivly retreives the elements from the memory array to be rendered. Only active
 * voxels are added to the render list. Active Voxels have a non air type.
 */
-(void)renderElements:(unsigned int *)elements;

/*!
 * @discussion Calculates the number of voxels in the octee.
 */
-(int)numberOfVoxels;

/*!
 * @discussion Updates the colours in the entire tree and subtress, at lowest level changes the 
 * the colour data at the end of the data pointer.
 */
-(void)updateColours:(colour *)newColour;

/*!
 * @discussion Checks to see whether the point lies within the octree.
 */
-(bool)collidesWithPoint:(vec3 *)point;

/*!
 * @discussion Moves through the tree until it finds the height 0 voxel which collides with the
 * point and changes the colour of that voxel.
 */
-(bool)updatePoint:(vec3 *)point withColour:(colour *)newColour;

/*!
 * @discussion Change the blockType of the tree to the given type. If the type is non air the
 * data for this voxel will be added to the render queue.
 */
-(void)updateType:(int)type;

/*!
 * @discussion Moves through the tree until it finds the height 0 voxel which collides with the
 * point and changes the blockType of that voxel.
 */
-(bool)updatePoint:(vec3 *)point withBlockType:(int)type;

/*!
 * @discussion Returns the type for the final node in the tree that collides with the point.
 */
-(int)typeForPoint:(vec3 *)point;

/*!
 * @discussion Returns the origin of the octree.
 */
-(vec3 *)origin;
@end
