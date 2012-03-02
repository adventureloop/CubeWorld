//
//  Matrix4.m
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Matrix4.h"

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

-(void)translateByVec3:(vec3 *)vec
{
    mat[3] = vec->x;
    mat[7] = vec->y;
    mat[11] = vec->z;
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
