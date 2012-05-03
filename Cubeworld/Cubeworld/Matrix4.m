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

-(void)rotateXByAngle:(float)angle
{
    float rads = degToRad(angle);
    float *tmp = calloc(16, sizeof(float));
    
    matrixLoadIdentity(tmp);
    
    tmp[5] = cosf(rads);
    tmp[6] = -sinf(rads);
    tmp[9] = sinf(rads);
    tmp[10] = cosf(rads);
    
    multiplyMatM4(tmp, mat, mat);
    
    free(tmp);
}

-(void)rotateYByAngle:(float)angle
{
    float rads = degToRad(angle);
    float *tmp = calloc(16, sizeof(float));
    
    matrixLoadIdentity(tmp);
    
    tmp[0] = cosf(rads);
    tmp[2] = sinf(rads);
    tmp[8] = -sinf(rads);
    tmp[10] = cosf(rads);
    
    multiplyMatM4(tmp, mat, mat);
    
    free(tmp);
}

-(void)rotateZByAngle:(float)angle
{
    float rads = degToRad(angle);
    float *tmp = calloc(16, sizeof(float));
    
    matrixLoadIdentity(tmp);
    
    tmp[0] = cosf(rads);
    tmp[1] = -sinf(rads);
    tmp[4] = sinf(rads);
    tmp[5] = cosf(rads);
    
    multiplyMatM4(tmp, mat, mat);
    
    free(tmp);
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
