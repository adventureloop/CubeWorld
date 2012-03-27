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
    return [self initWithNumberOfTrees:8 treeHeight:4];
}

-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight
{        
    if(self = [super init]) {
        trees = ntrees;
        treeHeight = ntreeHeight;
        
        //Find the cube root of the number voxels in a node
        //this gives the x and z widths of the chunk
        chunkWidth = pow(pow(8,treeHeight),1.0/3.0);
        
        nodes = [[NSMutableArray alloc]initWithCapacity:8];
        
        unsigned int numVoxels = trees * ((int)pow(8, treeHeight));
        unsigned int numElements = numVoxels * VOXEL_INDICES_COUNT;
        
        
        vertexData = calloc(numVoxels, sizeof(voxelData));
        indexArray = calloc(numElements, sizeof(unsigned int));
        tmpIndexArray = calloc(numElements, sizeof(long));
        
        memset(tmpIndexArray, -1, numElements * sizeof(int));
        
        nodeSize = 16.0;
        int offset = ((int)pow(8.0, treeHeight));
        voxelData *memPtr = (voxelData *)vertexData;
        

        localOrigin.x = 0.0;
        localOrigin.y = (nodeSize / 2);
        localOrigin.z = 0.0;
        
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
            
            [tmp release];
            
            memPtr += offset;
        }
        
        for(int i = 0,j = 0;i < numElements;i++) 
            if(tmpIndexArray[i] >= 0)
                indexArray[j++] = tmpIndexArray[i];
        
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
    if(needsUpdate) {
        [self update];
        needsUpdate = NO;
    }
    
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
    
    memset(indexArray, 0, numElements * sizeof(int));
    
    for(int i = 0,j = 0;i < numElements;i++) 
        if(tmpIndexArray[i] >= 0)
            indexArray[j++] = tmpIndexArray[i];
    
    free(tmpIndexArray);
    tmpIndexArray = nil;
    
    //Update the buffers on the GPU
    glBindVertexArrayAPPLE(vertexArrayObject);
    
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
//    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
    
    glBufferSubData(GL_ARRAY_BUFFER, 0, numVoxels * sizeof(voxelData), vertexData);
    glBufferSubData(GL_ELEMENT_ARRAY_BUFFER,0, numElements * sizeof(unsigned int), indexArray);
    
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glBindVertexArrayAPPLE(0);
}

-(int)voxelsToRender
{
    return trees * ((int)pow(8, treeHeight));
}

-(BOOL)updateBlockType:(int)type forPoint:(vec3 *)point
{
    if([self collidesWithPoint:point])
            for(Octnode *n in nodes)
                if([n collidesWithPoint:point])
                    return [n updatePoint:point withBlockType:type];
    return NO;
}

//Probably works
-(void)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z
{
    if(x > chunkWidth || x < 0)
        return;
    if(z > chunkWidth || z < 0)
        return;
    if(y > (chunkWidth * trees) || y < 0)
        return;
    
    int node = (int)y / (int)chunkWidth;
    
    y = (int)y % (int)chunkWidth;
    
    vec3 *origin = [[nodes objectAtIndex:node] origin];
    
    float voxelSize = (nodeSize / chunkWidth);
    float shift = 0.5 * chunkWidth * voxelSize;
    
    x = (x * voxelSize) + (0.5 * voxelSize);
    y = (y * voxelSize) + (0.5 * voxelSize);
    z = (z * voxelSize) + (0.5 * voxelSize);
    
    x -= shift;
    y -= shift;
    z -= shift;
    
    vec3 point;
    point.x = origin->x + x;
    point.y = origin->y + y;
    point.z = origin->z + z;
    
    for(Octnode *n in nodes)
        if([n collidesWithPoint:&point]) {
            [n updatePoint:&point withBlockType:type];
            needsUpdate = YES;
            break;
        }
}

-(bool)collidesWithPoint:(vec3 *)point
{
    return YES;
    float offset = nodeSize/2;
    if((point->x > (worldOrigin.x + offset) || point->x < (worldOrigin.x - offset)))
        return NO;
    
    if((point->z > (worldOrigin.z + offset) || point->z < (worldOrigin.z - offset)))
        return NO;
    
    offset = ([nodes count] * nodeSize)/2;
    if((point->y > (worldOrigin.y + offset) || point->y < (worldOrigin.y - offset)))
        return NO;
    
    return YES;
}

-(vec3 *)worldOrigin
{
    return &worldOrigin;
}

-(void)setWorldOrigin:(vec3 *)newOrigin
{
    worldOrigin.x = newOrigin->x;
    worldOrigin.y = newOrigin->y;
    worldOrigin.z = newOrigin->z;
}

-(float)chunkDimensions
{
    return nodeSize * chunkWidth;
}

-(void)updateAllToColour:(colour *)colour
{
    for(Octnode *o in nodes)
        [o updateColours:colour];
}

-(void)dealloc
{
    [nodes release];
    free(indexArray);
    free(vertexData);

    [super dealloc];
}
@end
