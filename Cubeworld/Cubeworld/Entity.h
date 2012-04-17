//
//  Entity.h
//  Cubeworld
//
//  Created by Tom Jones on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OctnodeLowMem.h"

/*!
 * @abstract Handles the Management of the data required to draw an Entity
 */
@interface Entity : NSObject
{
}

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

@end
