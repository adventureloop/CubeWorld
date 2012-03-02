//
//  Region.m
//  Cubeworld
//
//  Created by Tom Jones on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Region.h"

@implementation Region

-(id)initWithMatrixUnifLocation:(GLuint)unifLocation program:(GLuint)programLocation
{
    if(self = [super init]) {
        chunkManager = [[ChunkManager alloc]init];
        modelMatrix = [MatrixStack sharedMatrixStack];
        
        chunks = [[NSMutableArray alloc]init];
        
        focusPoint.x = 0;
        focusPoint.z = -3.0;
        focusPoint.y = 0;
        
        [chunks addObject:[[Chunk alloc]init]];
        [[chunks lastObject] setOrigin:&focusPoint];
        
        modelMatrixUnif = unifLocation;
        _program = programLocation;
    }
    return self;
}

-(void)render
{
    for(Chunk *c in chunks) {
        glUseProgram(_program);
        
        [modelMatrix push];
        [modelMatrix translateByVec3:[c origin]];
        
        glUniformMatrix4fv(modelMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
        
        [c render];
        
        [modelMatrix pop];
        glUseProgram(0);
    }
}

-(void)updateWithFocusPoint:(vec3 *)point
{
    
}
@end
