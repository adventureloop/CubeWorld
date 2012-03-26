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
        
        [chunks addObject:[chunkManager chunkForX:0 Z:0]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        focusPoint.x = -8.0;
        focusPoint.z = 8.0;
        
        [chunks addObject:[chunkManager chunkForX:0 Z:0]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        focusPoint.x = 8.0;
        focusPoint.z = -8.0;
        
        [chunks addObject:[chunkManager chunkForX:0 Z:0]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        focusPoint.x = -8.0;
        focusPoint.z = -8.0;
        
        [chunks addObject:[chunkManager chunkForX:0 Z:0]];
        [[chunks lastObject] setWorldOrigin:&focusPoint];
        
        modelMatrixUnif = unifLocation;
        transLationUnif = transLoc;
        _program = programLocation;
    }
    return self;
}

-(void)render
{
    float width = 8;
    
    for(Chunk *c in chunks) {
        glUseProgram(_program);
        
        [modelMatrix push];
      //  [modelMatrix translateByVec3:[c origin]];
        
        vec3 *trans = [c worldOrigin];
//        trans->x *= width;
//        trans->z *= width;
        
        glUniformMatrix4fv(modelMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
        glUniform3f(transLationUnif,trans->x,trans->y,trans->z);
        
        [c render];
        
        [modelMatrix pop];
        glUseProgram(0);
    }
}

-(void)updateWithFocusPoint:(vec3 *)point
{
    
}
@end
