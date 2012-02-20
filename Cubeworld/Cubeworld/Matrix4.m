//
//  Matrix4.m
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Matrix4.h"
#include "VectorMath.h"

@implementation Matrix4

-(id)init
{
    if(self = [super init])
        mat = calloc(16, sizeof(float));
    return self;
}

-(void)transpose
{
}

-(void)translateByVec4:(Vector4 *)vec
{
}

-(float *)mat
{
    return mat;
}

-(void)dealloc
{
    free(mat);
    
    [super dealloc];
}
@end
