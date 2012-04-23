//
//  SceneLoader.m
//  Cubeworld
//
//  Created by Tom Jones on 28/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SceneLoader.h"

@implementation SceneLoader

-(id)initWithBounds:(CGRect)newBounds
{
    if(self = [super initWithBounds:newBounds]) {
        chunkManager = [ChunkManager sharedChunkManager];
        resourceManager = [ResourceManager sharedResourceManager];
        
        [self setupOpenGL];
    }
    return self;
}

-(void)setupOpenGL
{
    NSLog(@"Setting up scene loader");
    
    //Allocate memory for vertex array
    vertexData = malloc(sizeof(voxelData));
    indexArray = malloc(12 * sizeof(unsigned int));
    
    [self addIndexes];
    
    outlineBox = (face *)vertexData;
    progressBox = (face *)vertexData+1;
    
    [self outlineBox];
    
    //Get the userinterface shager
    program = [resourceManager getProgramLocation:@"Ambient"];
    
    //Bind program locations
    
    //Create VAO
    glGenVertexArraysAPPLE(1, &vertexArrayObject);
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    //Create VBO
    glGenBuffers(1, &vertexBufferObject);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
    glBufferData(GL_ARRAY_BUFFER,sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &indexBufferObject);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 12 * sizeof(unsigned int), indexArray, GL_DYNAMIC_DRAW);
    
    //Enable Attributes and configure the memory layout
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);
    
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
    
    //Unbind the VAO to avoid someone making a mess
    glBindVertexArrayAPPLE(0);
}

-(void)render
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClearDepth(1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayAPPLE(vertexArrayObject);
    glUseProgram(program);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    
    if(glGetError() != 0)
        NSLog(@"GLError");
    
    glUseProgram(0);
    glBindVertexArrayAPPLE(0);
}

-(void)outlineBox
{
    outlineBox->vertex1.v.x = 0.1;
    outlineBox->vertex1.v.y = 0.4;
    outlineBox->vertex1.v.z = 0.0;
    outlineBox->vertex1.v.w = 0.0;
    
    outlineBox->vertex2.v.x = 0.1;
    outlineBox->vertex2.v.y = 0.6;
    outlineBox->vertex2.v.z = 0.0;
    outlineBox->vertex2.v.w = 0.0;
    
    outlineBox->vertex3.v.x = 0.9;
    outlineBox->vertex3.v.y = 0.4;
    outlineBox->vertex3.v.z = 0.0;
    outlineBox->vertex3.v.w = 0.0;
    
    outlineBox->vertex4.v.x = 0.9;
    outlineBox->vertex4.v.y = 0.6;
    outlineBox->vertex4.v.z = 0.0;
    outlineBox->vertex4.v.w = 0.0;
    
    colouredNormalVertex *v = (colouredNormalVertex *)outlineBox;
    for(int j = 0;j < 4;j++) { //This should be 4, but looks a lot better with an off by two
        v->c.red = 1.0;
        v->c.green = 1.0;
        v->c.blue = 1.0;
        v->c.alpha = 1.0;
        
        v += 1; //Get the next vertex
    }
}

-(void)addIndexes
{
    int i = 0;
    //Face 1
    indexArray[i++] = 0;
    indexArray[i++] = 1;
    indexArray[i++] = 2;

    indexArray[i++] = 2;
    indexArray[i++] = 3;
    indexArray[i++] = 0;

    //Face 2
    indexArray[i++] = 4;
    indexArray[i++] = 5;
    indexArray[i++] = 6;

    indexArray[i++] = 6;
    indexArray[i++] = 7;
    indexArray[i++] = 4;
}
@end
