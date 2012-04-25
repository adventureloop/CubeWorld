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
        chunkManager = [ChunkManager sharedChunkManager];
        modelMatrix = [MatrixStack sharedMatrixStack];
        
        resourceManager = [ResourceManager sharedResourceManager];
        program = [resourceManager getProgramLocation:@"Ambient"];
        
        modelMatrixUnif = glGetUniformLocation(program, "modelToWorldMatrix");
        transLocationUnif = glGetUniformLocation(program, "translation");
        
        offsetX = offsetZ = 0;
        renderDistance = 2;
    }
    return self;
}

-(void)render
{
    float width = 8;
    
    for(float x = renderDistance; x >= -renderDistance;x--) {
        for(float z = renderDistance;z >= -renderDistance;z--) {
            if(x == 0 || z == 0)
                continue;
            
            glUseProgram(program);
            
            glUniformMatrix4fv(modelMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
            glUniform3f(transLocationUnif,x*width,0,z*width);
            
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
    offsetX += x;
    offsetZ += z;
}

-(float)distanceBetweenA:(vec3 *)a B:(vec3 *)b
{
    return sqrtf(powf((a->x - b->x),2) + powf((a->z - b->z), 2));
}
@end
