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
        
        vertexData = calloc(1, sizeof(voxelData));
        
        
        glGenBuffers(1, &vertexBufferObject);
        
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glGenVertexArraysAPPLE(1, &vertexArrayObject);
        glBindVertexArrayAPPLE(vertexArrayObject);
        
        
        vec4 origin;
        origin.x = 1.0;
        origin.y = 1.0;
        origin.z = -2.0;
        
        node = [[Octnode alloc]initWithTreeHeight:0 nodeSize:1.0 orign:&origin memoryPointer:vertexData];
        
    }
    return self;
}

-(void)render;
{
	glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
	glEnableVertexAttribArray(0);
	glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);
    
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
    
	glDrawArrays(GL_LINES, 0, 24);
    
	glDisableVertexAttribArray(0);
	glDisableVertexAttribArray(1);
}
@end
