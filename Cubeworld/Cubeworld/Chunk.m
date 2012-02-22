//
//  Chunk.m
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Chunk.h"
#import <OpenGL/gl.h>

@implementation Chunk
-(id)init
{
    return [self initWithNumberOfTrees:1 treeHeight:1];
}

-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight
{        
    if(self = [super init]) {
        trees = ntrees;
        treeHeight = ntreeHeight;
        
        nodes = [[NSMutableArray alloc]initWithCapacity:8];
        
        unsigned int numVoxels = trees * ((int)pow(8, treeHeight));
        unsigned int numElements = numVoxels * VOXEL_INDICES_COUNT;
        
        float nodeSize = 1.0;
        int offset = ((int)pow(8.0, treeHeight));

        vertexData = calloc(numVoxels, sizeof(voxelData));
        indexArray = calloc(numElements, sizeof(unsigned int));
        
        vec4 origin;
        origin.x = 0.0 + (nodeSize / 2);
        origin.y = 0.0 + (nodeSize / 2);
        origin.z = 0.0 + (nodeSize / 2);
        
        for(int i = 0;i < trees;i++) {
            origin.y = (i * nodeSize) + (nodeSize/2);
            int memOffset = i * offset;
            int indexOffset = memOffset * VOXEL_INDICES_COUNT;
            
            Octnode *tmp = [[Octnode alloc]initWithTreeHeight:treeHeight 
                                             nodeSize:nodeSize 
                                                orign:&origin 
                                        memoryPointer:vertexData];
            [tmp renderElements:indexArray+memOffset offset:indexOffset];
            
            [nodes addObject:tmp];
        }
        
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

-(int)voxelsToRender
{
    return trees * ((int)pow(8, treeHeight));
}
@end
