//
//  Region.m
//  Cubeworld
//
//  Created by Tom Jones on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Region.h"

@implementation Region
@synthesize renderDistance;

-(id)initWithMatrixUnifLocation:(GLuint)unifLocation translationLocation:(GLuint)transLoc program:(GLuint)programLocation
{
    if(self = [super init]) {
        chunkManager = [ChunkManager sharedChunkManagerWithSeed:@"adventureloop" worldName:@"nil"];
        modelMatrix = [MatrixStack sharedMatrixStack];
        
        resourceManager = [ResourceManager sharedResourceManager];
        program = [resourceManager getProgramLocation:@"Ambient"];
        
        modelMatrixUnif = glGetUniformLocation(program, "modelToWorldMatrix");
        transLocationUnif = glGetUniformLocation(program, "translation");
        
        offsetX = offsetZ = 0;
        renderDistance = 1;
    }
    return self;
}

-(void)render
{
    float width = 16;
    float userX = (int)focusPoint.x % 16;
    float userZ = (int)focusPoint.z % 16;
    
    offsetX = (int)focusPoint.x / 16;
    offsetZ = (int)focusPoint.z / 16;
    
    for(float x = renderDistance; x >= -renderDistance;x--) {
        for(float z = renderDistance;z >= -renderDistance;z--) {
            
            glUseProgram(program);
            
            glUniform3f(transLocationUnif,x*width-userX,0,z*width-userZ);
            
            [[chunkManager chunkForX:x+offsetX Z:z+offsetZ] render];
            
            glUseProgram(0);
        }
    }
}

-(void)updateWithFocusPoint:(vec3 *)point
{
    focusPoint.x = point->x;
    focusPoint.y = point->y;
    focusPoint.z = point->z;
}

-(void)moveX:(float)x Z:(float)z
{
    focusPoint.x += x;
    focusPoint.z += z;
}

-(float)distanceBetweenA:(vec3 *)a B:(vec3 *)b
{
    return sqrtf(powf((a->x - b->x),2) + powf((a->z - b->z), 2));
}

-(void)serialize
{
    [chunkManager storeAllChunks];
}
@end
