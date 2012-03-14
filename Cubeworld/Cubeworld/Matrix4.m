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

-(void)uniformScale:(float)scale
{
    mat[0] *= scale;
    mat[5] *= scale;
    mat[10] *= scale;
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

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n%f\t%f\t%f\t%f\n%f\t%f\t%f\t%f\n%f\t%f\t%f\t%f\n%f\t%f\t%f\t%f\n",mat[0],mat[1],mat[2],mat[3],
                                                                                            mat[4],mat[5],mat[6],mat[7],
            mat[8],mat[9],mat[10],mat[11],
            mat[12],mat[13],mat[14],mat[15]];
}

-(void)dealloc
{
    free(mat);
    
    [super dealloc];
}
@end
