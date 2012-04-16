//
//  Chunk.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Octnode.h"

/*!
 * @abstract Chunk object, container for world voxels
 * @discussion Chunk object builds and maintain the octree hierarchy
 * it manages the placement of the trees and facilitates updates to 
 * trees through correct path. The Chunk manages the memory that is
 * used to render trees and is very tightly coupled with the octnode
 * class.
 */
@interface Chunk : NSObject
{
    GLuint vertexBufferObject;
    GLuint vertexArrayObject;
    GLuint indexBufferObject;
    NSMutableArray *nodes;
    
    float *vertexData;
    unsigned int *indexArray;
    int *tmpIndexArray;
    
    int trees;
    int treeHeight;
    float nodeSize;
    float chunkWidth;
    
    BOOL needsUpdate;
    
    vec3 localOrigin;
    vec3 worldOrigin;
}

/*!
 * @discussion Creates a new chunk with the specified number of trees 
 * matching the tree height parameter.
 */
-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight;

/*!
 * @discussion Renders all the voxels inside the chunk. Rendering will
 * block when updates are required to the memory mapped into the graphics
 * card.
 */
-(void)render;

/*!
 * @discussion Calculates the number of voxels inside the entire octree.
 */
-(int)voxelsToRender;

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
 */
-(BOOL)updateBlockType:(int) type forPoint:(vec3 *)point;

/*!
 * @discussion Update the block type for the voxel that matches up with the
 * index given. Calculates the position vector for the index given, then does
 * a updateBlockType: forPoint to do the actual update.
 */
-(void)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z;

/*!
 * @discussion Checks whether the chunk intersects with the given point
 */
-(bool)collidesWithPoint:(vec3 *)point;

/*!
 * @discussion Calculates the width in x and z for the chunk in world space
 * sizes.
 */
-(float)chunkDimensions;

/*!
 * @discussion Calculcates the height of the chunk, errrrrr.... I think
 */
-(int)height;

/*!
 * @discussion Updates every voxel in the chunk to the given colour
 */
-(void)updateAllToColour:(colour *)colour;
@end
