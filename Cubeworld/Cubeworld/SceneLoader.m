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
    vertexData = malloc(sizeof(face) * 2);
    indexArray = malloc(12 * sizeof(unsigned int));
    
    [self addIndexes];
    
    outlineBox = vertexData;
    progressBox = vertexData+sizeof(face);
    
    [self outlineBox];
    [self progressBox:0.5];
    
    //Get the userinterface shager
    program = [resourceManager getProgramLocation:@"UIShader"];
    
    //Bind program locations
    
    //Create VAO
    glGenVertexArraysAPPLE(1, &vertexArrayObject);
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    //Create VBO
    glGenBuffers(1, &vertexBufferObject);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
    glBufferData(GL_ARRAY_BUFFER,sizeof(face) * 2, vertexData, GL_DYNAMIC_DRAW);
    
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
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayAPPLE(vertexArrayObject);
    glUseProgram(program);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

    glUseProgram(0);
    glBindVertexArrayAPPLE(0);
    
    glSwapAPPLE();
    
    float renderDistance = 3;
    float width = 8;
    
    for(float x = renderDistance; x >= -renderDistance;x--) {
        for(float z = renderDistance;z >= -renderDistance;z--) {
            if(x == 0 || z == 0)
                continue;
            
            [chunkManager chunkForX:x Z:z];
        }
    }
}

-(void)outlineBox
{
    outlineBox->vertex1.v.x = -0.5;
    outlineBox->vertex1.v.y = -0.1;
    outlineBox->vertex1.v.z = 0.0;
    
    outlineBox->vertex2.v.x = -0.5;
    outlineBox->vertex2.v.y = 0.1;
    outlineBox->vertex2.v.z = 0.0;
    
    outlineBox->vertex3.v.x = 0.5;
    outlineBox->vertex3.v.y = 0.1;
    outlineBox->vertex3.v.z = 0.0;
    
    outlineBox->vertex4.v.x = 0.5;
    outlineBox->vertex4.v.y = -0.1;
    outlineBox->vertex4.v.z = 0.0;
    
    
    //Horrify the colours
    outlineBox->vertex1.c.red = 0.6;
    outlineBox->vertex1.c.green = 0.6;
    outlineBox->vertex1.c.blue = 0.6;
    outlineBox->vertex1.c.alpha = 1.0;
    
    outlineBox->vertex2.c.red = 0.6;
    outlineBox->vertex2.c.green = 0.6;
    outlineBox->vertex2.c.blue = 0.6;
    outlineBox->vertex2.c.alpha = 1.0;
    
    outlineBox->vertex3.c.red = 0.6;
    outlineBox->vertex3.c.green = 0.6;
    outlineBox->vertex3.c.blue = 0.6;
    outlineBox->vertex3.c.alpha = 1.0;
    
    outlineBox->vertex4.c.red = 0.6;
    outlineBox->vertex4.c.green = 0.6;
    outlineBox->vertex4.c.blue = 0.6;
    outlineBox->vertex4.c.alpha = 1.0;
}

-(void)progressBox:(float)percentage
{
    //Set start position
    progressBox->vertex1.v.x = outlineBox->vertex1.v.x;// + 0.01;
    progressBox->vertex1.v.y = outlineBox->vertex1.v.y;// + 0.01;   
    progressBox->vertex1.v.z = outlineBox->vertex1.v.z;
    
    progressBox->vertex2.v.x = outlineBox->vertex1.v.x;// + 0.01;
    progressBox->vertex2.v.y = outlineBox->vertex1.v.y;// - 0.01;   
    progressBox->vertex2.v.z = outlineBox->vertex1.v.z;
    
    //Calculate x span
    float span = outlineBox->vertex1.v.x - outlineBox->vertex4.v.x;
    span = percentage * span;
    
    progressBox->vertex3.v.x = outlineBox->vertex3.v.x;// -0.01;
    progressBox->vertex3.v.y = outlineBox->vertex3.v.y;// - 0.01;    
    progressBox->vertex3.v.z = outlineBox->vertex3.v.z;
    
    progressBox->vertex4.v.x = outlineBox->vertex4.v.x;// - 0.01;
    progressBox->vertex4.v.y = outlineBox->vertex4.v.y;// + 0.01;    
    progressBox->vertex4.v.z = outlineBox->vertex4.v.z;
    
    //Horrify the colours
    progressBox->vertex1.c.red = 0.0;
    progressBox->vertex1.c.green = 0.0;
    progressBox->vertex1.c.blue = 1.0;
    progressBox->vertex1.c.alpha = 1.0;
    
    progressBox->vertex2.c.red = 0.0;
    progressBox->vertex2.c.green = 0.0;
    progressBox->vertex2.c.blue = 1.0;
    progressBox->vertex2.c.alpha = 1.0;
    
    progressBox->vertex3.c.red = 0.0;
    progressBox->vertex3.c.green = 0.0;
    progressBox->vertex3.c.blue = 1.0;
    progressBox->vertex3.c.alpha = 1.0;
    
    progressBox->vertex4.c.red = 0.0;
    progressBox->vertex4.c.green = 0.0;
    progressBox->vertex4.c.blue = 1.0;
    progressBox->vertex4.c.alpha = 1.0;
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
