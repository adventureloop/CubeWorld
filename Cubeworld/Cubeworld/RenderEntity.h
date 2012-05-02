//
//  RenderEntity.h
//  Cubeworld
//
//  Created by Tom Jones on 02/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OctnodeLowMem.h"
#import "ResourceManager.h"

/*!
 * @abstract Handles rendering and storage of the mesh for an Entity
 */
@interface RenderEntity : NSObject
{
    GLuint program;
    ResourceManager *resourceManager;
    
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
    float entityWidth;
    
    OctnodeLowMem *box;
    
    BOOL needsUpdate;
}
-(id)initWithTreeHeight:(int)height size:(float)asize;

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

-(void)render;
@end
