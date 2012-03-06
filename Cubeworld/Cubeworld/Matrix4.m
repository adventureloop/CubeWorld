//
//  Matrix4.m
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Matrix4.h"
//#import "VectorMath.h"

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

-(void)loadIndentity
{
    matrixLoadIdentity(mat);
}

-(void)rotateByAngle:(float)angle axisX:(float)x Y:(float)y Z:(float)z
{
    vec3 axis;
    axis.x = x;
    axis.y = y;
    axis.z = z;
    
    float c = cosf(angle);
    float s = sinf(angle);
    float ac = 1 - c;

    mat[0] = axis.x * axis.x * ac + c;
    mat[1] = axis.x * axis.y * ac + axis.z * s;
    mat[2] = axis.x * axis.z * ac - axis.y * s;

    mat[4] = axis.y * axis.x * ac - axis.z * s;
    mat[5] = axis.y * axis.y * ac + c;
    mat[6] = axis.y * axis.z * ac + axis.x * s;

    mat[8] = axis.z * axis.x * ac + axis.y * s;
    mat[9] = axis.z * axis.y * ac - axis.x * s;
    mat[10] = axis.z * axis.z * ac + c;
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
