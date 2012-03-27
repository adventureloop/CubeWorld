//
//  Region.m
//  Cubeworld
//
//  Created by Tom Jones on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Region.h"

@implementation Region

-(id)initWithMatrixUnifLocation:(GLuint)unifLocation translationLocation:(GLuint)transLoc program:(GLuint)programLocation
{
    if(self = [super init]) {
        chunkManager = [[ChunkManager alloc]init];
        modelMatrix = [MatrixStack sharedMatrixStack];
        
        chunks = [[NSMutableArray alloc]init];
        
        focusPoint.x = 8.0;
        focusPoint.y = 0.0;
        focusPoint.z = 8.0;
        
        [chunks addObject:[chunkManager chunkForX:1 Z:0]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        focusPoint.x = -8.0;
        focusPoint.z = 8.0;
        
        [chunks addObject:[chunkManager chunkForX:1 Z:1]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        focusPoint.x = 8.0;
        focusPoint.z = -8.0;
        
        [chunks addObject:[chunkManager chunkForX:-1 Z:0]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        focusPoint.x = -8.0;
        focusPoint.z = -8.0;
        
        [chunks addObject:[chunkManager chunkForX:-1 Z:-1]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        modelMatrixUnif = unifLocation;
        transLationUnif = transLoc;
        _program = programLocation;
    }
    return self;
}

-(void)render
{
    float renderDistance = 2;
    float width = 8;
    
    for(float x = renderDistance; x >= -renderDistance;x--) {
        for(float z = renderDistance;z >= -renderDistance;z--) {
            if(x == 0 || z == 0)
                continue;
            
            glUseProgram(_program);
            
            glUniformMatrix4fv(modelMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
            glUniform3f(transLationUnif,x*width,0,z*width);
            
            [[chunkManager chunkForX:x Z:z] render];
            
            glUseProgram(0);
        }
    }
}

-(void)updateWithFocusPoint:(vec3 *)point
{
    
}
@end
