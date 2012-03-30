//
//  Chunk.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OctnodeLowMem.h"

#define ALLOC_SIZE 256

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
}
-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight;

-(void)render;
-(int)voxelsToRender;

-(void)getRenderMetaData:(int *)offset DataPtr:(voxelData *)ptr;

-(vec3 *)worldOrigin;
-(void)setWorldOrigin:(vec3 *)newOrigin;

-(void)update;

-(BOOL)updateBlockType:(int) type forPoint:(vec3 *)point;
-(void)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z;
-(bool)collidesWithPoint:(vec3 *)point;

-(float)chunkDimensions;
-(int)height;

-(void)updateAllToColour:(colour *)colour;
@end
