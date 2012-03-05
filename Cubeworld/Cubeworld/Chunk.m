//
//  Chunk.m
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Chunk.h"
#import <OpenGL/gl.h>
#import "BlockTypes.h"

@implementation Chunk
-(id)init
{
    return [self initWithNumberOfTrees:8 treeHeight:1];
}

-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight
{        
    if(self = [super init]) {
        trees = ntrees;
        treeHeight = ntreeHeight;
        
        nodes = [[NSMutableArray alloc]initWithCapacity:8];
        
        unsigned int numVoxels = trees * ((int)pow(8, treeHeight));
        unsigned int numElements = numVoxels * VOXEL_INDICES_COUNT;
        
        
        vertexData = calloc(numVoxels, sizeof(voxelData));
        indexArray = calloc(numElements, sizeof(unsigned int));
        tmpIndexArray = calloc(numElements, sizeof(long));
        
        memset(tmpIndexArray, -1, numElements * sizeof(int));
        
        float nodeSize = 1.0;
        int offset = ((int)pow(8.0, treeHeight));
        voxelData *memPtr = (voxelData *)vertexData;
        
        vec4 localOrigin;
        localOrigin.x = 0.0;
        localOrigin.y = (nodeSize / 2);
        localOrigin.z = -3.0;
        
        for(int i = 0;i < trees;i++) {
            localOrigin.y = (i * nodeSize) + (nodeSize/2);
            
            int memOffset = i * offset;
            int indexOffset = memOffset * VOXEL_INDICES_COUNT;
            int arrayOffset = memOffset * 24;
            
            Octnode *tmp = [[Octnode alloc]initWithTreeHeight:treeHeight 
                                             nodeSize:nodeSize 
                                                orign:&localOrigin 
                                        memoryPointer:memPtr];
            [tmp renderElements:tmpIndexArray+indexOffset offset:arrayOffset];
            [nodes addObject:tmp];
            
            memPtr += offset;
        }
        
        for(int i = 0,j = 0;i < numElements;i++) 
            if(tmpIndexArray[i] >= 0)
                indexArray[j++] = tmpIndexArray[i];
            
        
        /* This code needs moved*/
        
        colour newColour;
        newColour.red = 0.0;
        newColour.green = 0.0;
        newColour.blue = 1.0;
        newColour.alpha = 1.0;
        
        localOrigin.x = 0.1;
        localOrigin.z = -3.1;
        localOrigin.y = 0.6;
        
        [[nodes objectAtIndex:0] updatePoint:&localOrigin withBlockType:BLOCK_AIR];
        
        [self update];
        
        /*Testing code to be removed ends*/
        
        
        /* Set up vertex buffer and array objects */
        glGenBuffers(1, &vertexBufferObject);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER,numVoxels * sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glGenBuffers(1, &indexBufferObject);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, numElements * sizeof(unsigned int), indexArray, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
        glGenVertexArraysAPPLE(1, &vertexArrayObject);
        glBindVertexArrayAPPLE(vertexArrayObject);
        
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        
        glEnableVertexAttribArray(0);
        glEnableVertexAttribArray(1);
        glEnableVertexAttribArray(2);
        
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
        glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        
        glBindVertexArrayAPPLE(0);
        
        free(tmpIndexArray);
        tmpIndexArray = nil;
    }
    return self;
}

-(void)render;
{
    int numElements = [self voxelsToRender] * VOXEL_INDICES_COUNT;
    
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glDrawElements(GL_TRIANGLES, numElements, GL_UNSIGNED_INT, 0);
    glBindVertexArrayAPPLE(0);
}

-(void)update
{
    unsigned int numVoxels = trees * ((int)pow(8, treeHeight));
    unsigned int numElements = numVoxels * VOXEL_INDICES_COUNT;
    int offset = ((int)pow(8.0, treeHeight));
    
    if(tmpIndexArray == nil)
        tmpIndexArray = calloc(numElements, sizeof(long));
        
    memset(tmpIndexArray, -1, numElements * sizeof(int));
    
    for(int i = 0;i < trees;i++) {
        
        int memOffset = i * offset;
        int indexOffset = memOffset * VOXEL_INDICES_COUNT;
        int arrayOffset = memOffset * 24;
        
        Octnode *tmp = [nodes objectAtIndex:i];
        [tmp renderElements:tmpIndexArray+indexOffset offset:arrayOffset];
        [nodes addObject:tmp];
    }
    for(int i = 0,j = 0;i < numElements;i++) 
        if(tmpIndexArray[i] >= 0)
            indexArray[j++] = tmpIndexArray[i];
    free(tmpIndexArray);
    tmpIndexArray = nil;
}

-(int)voxelsToRender
{
    return trees * ((int)pow(8, treeHeight));
}

-(vec3 *)origin
{
    return &origin;
}

-(void)setOrigin:(vec3 *)newOrigin
{
    origin.x = newOrigin->x;
    origin.y = newOrigin->y;
    origin.z = newOrigin->z;
}
@end
