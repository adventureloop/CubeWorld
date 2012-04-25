//
//  SkyBox.m
//  Cubeworld
//
//  Created by Tom Jones on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SkyBox.h"
#import <OpenGL/gl.h>
#import "MatrixStack.h"
#import "BlockTypes.h"

@implementation SkyBox

-(id)initWithSize:(float)asize
{
    if(self = [super init]) {
        size = asize;
        
        vertexData = malloc(sizeof(voxelData));
        
        indexArray = malloc(VOXEL_INDICES_COUNT * sizeof(unsigned int));
        int *tmpIndexArray = malloc(VOXEL_INDICES_COUNT * sizeof(long));
        
        memset(tmpIndexArray, -1, VOXEL_INDICES_COUNT * sizeof(int));
        
        //Create the sky box        
        vec3 localOrigin;
        localOrigin.x = 0.0;
        localOrigin.y = 0.0;
        localOrigin.z = 0.0;
        
        box =  [[OctnodeLowMem alloc]initWithTreeHeight:0
                                         nodeSize:size
                                            orign:&localOrigin 
                                    dataSource:self];
        [box updateType:BLOCK_SKY_DAY]; //Set to block sky
        [box invertNormals];
        [box renderElements:tmpIndexArray];
        
        for(int i = 0,j = 0;i < VOXEL_INDICES_COUNT;i++) 
            if(tmpIndexArray[i] >= 0)
                indexArray[j++] = tmpIndexArray[i];
        free(tmpIndexArray);
        
        //Create VAO
        glGenVertexArraysAPPLE(1, &vertexArrayObject);
        glBindVertexArrayAPPLE(vertexArrayObject);
        
        //Create VBO
        glGenBuffers(1, &vertexBufferObject);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER,sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
        
        
        //Create element array
        glGenBuffers(1, &indexBufferObject);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,VOXEL_INDICES_COUNT * sizeof(unsigned int), indexArray, GL_DYNAMIC_DRAW);
        
        //Enable Attributes and configure the memory layout
        glEnableVertexAttribArray(0);
        glEnableVertexAttribArray(1);
        glEnableVertexAttribArray(2);
        
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
        glVertexAttribPointer(2, 3, GL_SHORT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
        
        //Unbind the VAO to avoid someone making a mess
        glBindVertexArrayAPPLE(0);
        
        //Grab the program to use
        resourceManager = [ResourceManager sharedResourceManager];
        program = [resourceManager getProgramLocation:@"Ambient"];
        
        glUseProgram(program);
        transLocationUnif = glGetUniformLocation(program, "translation");
        modelMatrixUnif = glGetUniformLocation(program, "modelToWorldMatrix");
        
        fogColourUnif = glGetUniformLocation(program, "fogColour");
        fogNearUnif = glGetUniformLocation(program, "fogNear");
        fogFarUnif = glGetUniformLocation(program, "fogFar");
        
        fogColour.red = 0.5;
        fogColour.green = 0.5;
        fogColour.blue = 0.7;
        
        fogFar = size + size/3;
        fogNear = size * 0.2;
        
        glUniform3f(fogColourUnif, fogColour.red,fogColour.green, fogColour.blue);
        glUniform1f(fogFarUnif, fogFar);
        glUniform1f(fogNearUnif, fogNear);
        glUseProgram(0);
    }
    return self;
}

-(void)render
{
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glFrontFace(GL_CCW);
    
    glUseProgram(program);
    glUniformMatrix4fv(modelMatrixUnif, 1, GL_FALSE,[[MatrixStack sharedMatrixStack] mat]);
    glUniform3f(transLocationUnif,0,56,0);
    glDrawElements(GL_TRIANGLES, VOXEL_INDICES_COUNT, GL_UNSIGNED_INT, 0);
    
    glFrontFace(GL_CW);
    glUseProgram(0);
    glBindVertexArrayAPPLE(0);
}

-(void)update
{
    fogColour.red = 0.5;
    fogColour.green = 0.5;
    fogColour.blue = 0.7;
    
    fogFar = size + size/3;
    fogNear = fogFar * 0.2;
    
    glUseProgram(program);
    glUniform3f(fogColourUnif, fogColour.red,fogColour.green, fogColour.blue);
    glUniform1f(fogFarUnif, fogFar);
    glUniform1f(fogNearUnif, fogNear);
    glUseProgram(0);
    
    [box release];
    
    int *tmpIndexArray = malloc(VOXEL_INDICES_COUNT * sizeof(long));
    
    memset(tmpIndexArray, -1, VOXEL_INDICES_COUNT * sizeof(int));
    
    //Create the sky box        
    vec3 localOrigin;
    localOrigin.x = 0.0;
    localOrigin.y = 0.0;
    localOrigin.z = 0.0;
    
    box =  [[OctnodeLowMem alloc]initWithTreeHeight:0
                                           nodeSize:size
                                              orign:&localOrigin 
                                         dataSource:self];
    [box updateType:BLOCK_SKY_DAY]; //Set to block sky
    [box invertNormals];
    [box renderElements:tmpIndexArray];
    
    for(int i = 0,j = 0;i < VOXEL_INDICES_COUNT;i++) 
        if(tmpIndexArray[i] >= 0)
            indexArray[j++] = tmpIndexArray[i];
    free(tmpIndexArray);
    
    //Update the buffers on the GPU
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glBufferData(GL_ARRAY_BUFFER,sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,VOXEL_INDICES_COUNT * sizeof(unsigned int), indexArray, GL_DYNAMIC_DRAW);
    
    glBindVertexArrayAPPLE(0);
}

-(void)setSize:(float)asize
{
    size = asize;
    [self update];
}

-(voxelData *)getRenderMetaData:(int *)offset
{
    voxelData *memPtr = (voxelData *)vertexData;
    
    *offset = 0;
    return memPtr;
}

-(voxelData *)updateRenderMetaData:(int)offset
{
    voxelData *memPtr = (voxelData *)vertexData;
    
    return memPtr;
}

-(void)dealloc
{   
    [box release];
    
    free(vertexData);
    free(indexArray);
    
    [super dealloc];
}
@end