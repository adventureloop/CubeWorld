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
    if(self = [super init]) {
        indexArray = calloc(36, sizeof(int));
        vertexData = calloc(1, sizeof(voxelData));
        
        indexArray[0] = 1;
        indexArray[1] = 2;
        indexArray[2] = 0;
        
        vec4 origin;
        origin.x = 0.0;
        origin.y = 0.0;
        origin.z = -2.0;
        
        node = [[Octnode alloc]initWithTreeHeight:0 nodeSize:1.0 orign:&origin memoryPointer:vertexData];
    
        glGenBuffers(1, &vertexBufferObject);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glGenBuffers(1, &indexBufferObject);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, 36 * sizeof(int), indexArray, GL_DYNAMIC_DRAW);
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
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_INT, 0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glBindVertexArrayAPPLE(0);
}
@end
