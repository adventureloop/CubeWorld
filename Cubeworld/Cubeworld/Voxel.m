//
//  Voxel.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voxel.h"
#import <OpenGL/gl.h>

@implementation Voxel

const float vertexData2[] = {
    
    0.5f,  0.5f, 0.5f, 1.0f,
    0.5f, -0.5f, 0.5f, 1.0f,
    -0.5f,  0.5f, 0.5f, 1.0f,
    
    0.5f, -0.5f, 0.5f, 1.0f,
    -0.5f, -0.5f, 0.5f, 1.0f,
    -0.5f,  0.5f, 0.5f, 1.0f,
    
    0.5f,  0.5f, -0.5f, 1.0f,
    -0.5f,  0.5f, -0.5f, 1.0f,
    0.5f, -0.5f, -0.5f, 1.0f,
    
    0.5f, -0.5f, -0.5f, 1.0f,
    -0.5f,  0.5f, -0.5f, 1.0f,
    -0.5f, -0.5f, -0.5f, 1.0f,
    
    -0.5f,  0.5f, 0.5f, 1.0f,
    -0.5f, -0.5f, 0.5f, 1.0f,
    -0.5f, -0.5f, -0.5f, 1.0f,
    
    -0.5f,  0.5f, 0.5f, 1.0f,
    -0.5f, -0.5f, -0.5f, 1.0f,
    -0.5f,  0.5f, -0.5f, 1.0f,
    
    0.5f,  0.5f, 0.5f, 1.0f,
    0.5f, -0.5f, -0.5f, 1.0f,
    0.5f, -0.5f, 0.5f, 1.0f,
    
    0.5f,  0.5f, 0.5f, 1.0f,
    0.5f,  0.5f, -0.5f, 1.0f,
    0.5f, -0.5f, -0.5f, 1.0f,
    
    0.5f,  0.5f, -0.5f, 1.0f,
    0.5f,  0.5f, 0.5f, 1.0f,
    -0.5f,  0.5f, 0.5f, 1.0f,
    
    0.5f,  0.5f, -0.5f, 1.0f,
    -0.5f,  0.5f, 0.5f, 1.0f,
    -0.5f,  0.5f, -0.5f, 1.0f,
    
    0.5f, -0.5f, -0.5f, 1.0f,
    -0.5f, -0.5f, 0.5f, 1.0f,
    0.5f, -0.5f, 0.5f, 1.0f,
    
    0.5f, -0.5f, -0.5f, 1.0f,
    -0.5f, -0.5f, -0.5f, 1.0f,
    -0.5f, -0.5f, 0.5f, 1.0f,
    
    
	0.0f, 0.0f, 1.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
    
	0.0f, 0.0f, 1.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
    
	0.8f, 0.8f, 0.8f, 1.0f,
	0.8f, 0.8f, 0.8f, 1.0f,
	0.8f, 0.8f, 0.8f, 1.0f,
    
	0.8f, 0.8f, 0.8f, 1.0f,
	0.8f, 0.8f, 0.8f, 1.0f,
	0.8f, 0.8f, 0.8f, 1.0f,
    
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
    
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
    
	0.5f, 0.5f, 0.0f, 1.0f,
	0.5f, 0.5f, 0.0f, 1.0f,
	0.5f, 0.5f, 0.0f, 1.0f,
    
	0.5f, 0.5f, 0.0f, 1.0f,
	0.5f, 0.5f, 0.0f, 1.0f,
	0.5f, 0.5f, 0.0f, 1.0f,
    
	1.0f, 0.0f, 0.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
    
	1.0f, 0.0f, 0.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
    
	0.0f, 1.0f, 1.0f, 1.0f,
	0.0f, 1.0f, 1.0f, 1.0f,
	0.0f, 1.0f, 1.0f, 1.0f,
    
	0.0f, 1.0f, 1.0f, 1.0f,
	0.0f, 1.0f, 1.0f, 1.0f,
	0.0f, 1.0f, 1.0f, 1.0f,
};

-(id)init
{
    if(self = [super init]) {
        glGenBuffers(1, &vertexBufferObject);
        
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData2), vertexData2, GL_STATIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glGenVertexArraysAPPLE(1, &vertexArrayObject);
        glBindVertexArrayAPPLE(vertexArrayObject);
    
    }
    return self;
}

-(void)render;
{
    size_t colorData = sizeof(vertexData2) / 2;
	glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
	glEnableVertexAttribArray(0);
	glEnableVertexAttribArray(1);
    
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);
	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, (void*)colorData);
    
	glDrawArrays(GL_TRIANGLES, 0, 36);
    
	glDisableVertexAttribArray(0);
	glDisableVertexAttribArray(1);
}
@end
