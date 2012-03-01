//
//  Region.m
//  Cubeworld
//
//  Created by Tom Jones on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Region.h"

@implementation Region

-(id)init
{
    if(self = [super init]) {
        chunkManager = [[ChunkManager alloc]init];
        modelMatrix = [[MatrixStack alloc]init];
        
        chunks = [[NSMutableArray alloc]init];
        
        focusPoint.x = 0;
        focusPoint.z = 0;
        focusPoint.y = 0;
    }
    return self;
}

-(void)render
{
    for(Chunk *c in chunks) {
        glUseProgram(_program);
        [modelMatrix push];
//        [modelMatrix translateByVec4:[c origin]];
//        glUniformMatrix4fv(modelMatrixUnif, 1, GL_FALSE, modelMatrix);
        [c render];
        
        [modelMatrix pop];
        glUseProgram(0);
    }
}

-(void)updateWithFocusPoint:(vec3 *)point
{
    
}
@end
