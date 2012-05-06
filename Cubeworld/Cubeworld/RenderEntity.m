//
//  RenderEntity.m
//  Cubeworld
//
//  Created by Tom Jones on 02/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderEntity.h"
#import "BlockTypes.h"

#import <OpenGL/gl.h>

@implementation RenderEntity


#define ALLOC_SIZE 8

-(id)initWithTreeHeight:(int)height size:(float)asize
{        
    if(self = [super init]) {
        treeHeight = height;
        nodeSize = asize;
        
        //Find the cube root of the number voxels in a node
        //this gives the x and z widths of the chunk
        entityWidth = pow(pow(8,treeHeight),1.0/3.0);
        
        maxVoxels = pow(8,treeHeight);
        
        unsigned int numElements = ((int)pow(8, treeHeight)) * VOXEL_INDICES_COUNT;
        
        vertexData = calloc(maxVoxels, sizeof(voxelData));
        
        indexArray = calloc(numElements, sizeof(unsigned int));
        tmpIndexArray = malloc(numElements * sizeof(long));
        
        memset(tmpIndexArray, -1, numElements * sizeof(int));
        
        nodeSize = asize;
        
        vec3 localOrigin;
        localOrigin.x = 0.0;
        localOrigin.y = 0.0;
        localOrigin.z = 0.0;
        
        node = [[OctnodeLowMem alloc]initWithTreeHeight:treeHeight 
                                                             nodeSize:nodeSize 
                                                                orign:&localOrigin 
                                                           dataSource:self];
        [node renderElements:tmpIndexArray];
        
        
        for(int i = 0,j = 0;i < numElements;i++) 
            if(tmpIndexArray[i] >= 0)
                indexArray[j++] = tmpIndexArray[i];
        
        /* Set up vertex buffer and array objects */
        glGenBuffers(1, &vertexBufferObject);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER,maxVoxels * sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
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
        
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
        glVertexAttribPointer(2, 3, GL_SHORT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        
        glBindVertexArrayAPPLE(0);
        
        free(tmpIndexArray);
        tmpIndexArray = nil;
    }
    return self;
}

-(void)render
{
    if(needsUpdate)
        [self update];
    
    int numElements = [self voxelsToRender] * VOXEL_INDICES_COUNT;
    
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glDrawElements(GL_TRIANGLES, numElements, GL_UNSIGNED_INT, 0);
    glBindVertexArrayAPPLE(0);
}

-(voxelData *)getRenderMetaData:(int *)offset
{
    if(voxelCounter > maxVoxels-1) {
        maxVoxels += ALLOC_SIZE;
        NSLog(@"Increasing memory size in chunk to hold %d",maxVoxels);
        vertexData =  realloc(vertexData, (voxelCounter + ALLOC_SIZE) * sizeof(voxelData));
    }
    
    voxelData *memPtr = (voxelData *)vertexData;
    
    *offset = voxelCounter * 24;
    return memPtr+voxelCounter++;
}

-(voxelData *)updateRenderMetaData:(int)offset
{
    voxelData *memPtr = (voxelData *)vertexData;
    
    return memPtr+(offset/24);
}

-(int)voxelsToRender
{
    return ((int)pow(8, treeHeight));
}

-(void)point:(vec3 *)point forX:(float)x Y:(float)y Z:(float)z
{
    if(x > entityWidth || x < 0)
        return;
    if(z > entityWidth || z < 0)
        return;
    if(y > entityWidth || y < 0)
        return;
    
    y = (int)y % (int)entityWidth;
    
    vec3 *origin = [node origin];
    
    float voxelSize = (nodeSize /entityWidth);
    float shift = 0.5 *entityWidth * voxelSize;
    
    x = (x * voxelSize) + (0.5 * voxelSize);
    y = (y * voxelSize) + (0.5 * voxelSize);
    z = (z * voxelSize) + (0.5 * voxelSize);
    
    x -= shift;
    y -= shift;
    z -= shift;
    
    point->x = origin->x + x;
    point->y = origin->y + y;
    point->z = origin->z + z;
}

-(void)update
{
    tmpIndexArray = malloc(VOXEL_INDICES_COUNT * sizeof(long));
    
    memset(tmpIndexArray, -1, VOXEL_INDICES_COUNT * sizeof(int));
    
    [node renderElements:tmpIndexArray];
    
    for(int i = 0,j = 0;i < VOXEL_INDICES_COUNT;i++) 
        if(tmpIndexArray[i] >= 0)
            indexArray[j++] = tmpIndexArray[i];
    free(tmpIndexArray);
    
    //Update the buffers on the GPU
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glBufferData(GL_ARRAY_BUFFER,sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,VOXEL_INDICES_COUNT * sizeof(unsigned int), indexArray, GL_DYNAMIC_DRAW);
    
    glBindVertexArrayAPPLE(0);
    
    needsUpdate = NO;
}

-(void)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z
{
    vec3 point;
    [self point:&point forX:x Y:y Z:z];
    
    if([node collidesWithPoint:&point]) 
        [node updatePoint:&point withBlockType:type];
    needsUpdate = YES;
}

-(int)blockTypeForX:(float)x Y:(float)y Z:(float)z
{
    vec3 point;
    [self point:&point forX:x Y:y Z:z];
    
    if([node collidesWithPoint:&point])
        return [node typeForPoint:&point];
    return BLOCK_AIR;
}
@end
