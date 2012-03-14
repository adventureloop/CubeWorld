//
//  VectorMath.h
//  Cubeworld
//
//  Created by Tom Jones on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <Accelerate/Accelerate.h>

float degToRad(float);
float magnitudeV3(vec3 *);
void normalizeV3(vec3 *, vec3 *);
void subtractV3(vec3 *, vec3 *, vec3 *);

void crossV3(vec3 *, vec3 *, vec3 *);
float dotV3(vec3 *,vec3 *);
void vecByScalarV3(vec3 *,float scalar,vec3 *);
void addV3(vec3 *,vec3 *invec2,vec3 *);

void matrixDiagMatrixM4(float *,float);
void matrixLoadIdentity(float *);
void matrixSetAllToScalarM4(float *, float );
void matrixSetVectorV3M4(float *, vec3 *, int );
void multiplyMatM4(float *, float *,float *);
void transposeMatM4(float *mat);


float degToRad(float fAngDeg)
{
    const float fDegToRad = 3.14159f * 2.0f / 360.0f;
    return fAngDeg * fDegToRad;
}

float magnitudeV3(vec3 *invec)
{
    return sqrt( (invec->x * invec->x) + (invec->y * invec->y) + (invec->z * invec->z));
}

//Normalize invec, store result in outvec
void normalizeV3(vec3 *invec, vec3 *outvec)
{
    float len = magnitudeV3(invec);
    
    outvec->x = invec->x / len;
    outvec->y = invec->y / len;
    outvec->z = invec->z / len;
}

//Substract invec2 from invec1, store result in outvec

void subtractV3(vec3 *invec1, vec3 *invec2, vec3 *outvec)
{
    outvec->x = invec1->x - invec2->x;
    outvec->y = invec1->y - invec2->y; 
    outvec->z = invec1->z - invec2->z;
}


//Calculate the cross product of invec1 and invec2, store in outvec
void crossV3(vec3 *invec1, vec3 *invec2, vec3 *outvec)
{
    outvec->x = invec1->y * invec2->z - invec1->z * invec2->y;
    outvec->y = invec1->z * invec2->x - invec1->x * invec2->z;
    outvec->z = invec1->x * invec2->y - invec1->y * invec2->x;
}

//Calculate the dot product of invec1 and invec2
float dotV3(vec3 *invec1,vec3 *invec2)
{
    return (invec1->x * invec2->x) + (invec1->y * invec2->y) + (invec1->z * invec2->z);
}

void vecByScalarV3(vec3 *invec,float scalar,vec3 *outvec)
{
	outvec->x = invec->x * scalar;   
	outvec->y = invec->y * scalar;   
	outvec->z = invec->z * scalar;   
}

void addV3(vec3 *invec1,vec3 *invec2,vec3 *outvec)
{
	outvec->x = invec1->x + invec2->x;
	outvec->y = invec1->y + invec2->y;
	outvec->z = invec1->z + invec2->z;
    
}


void matrixDiagMatrixM4(float *mat,float scalar)
{
    mat[0] = scalar;
    mat[5] = scalar;
    mat[10] = scalar;
    mat[15] = scalar;
}

void matrixLoadIdentity(float *mat)
{
    for(int i = 0;i < 16;i++)
        mat[i] = 0.0f;
    
    matrixDiagMatrixM4(mat, 1.0);
}

void matrixSetAllToScalarM4(float *mat, float scalar)
{
    int i;
    for(i = 0;i < 16; i++)
        mat[i] = scalar;
}

void matrixSetVectorV3M4(float *mat, vec3 *vec, int index)
{
    mat[index++] = vec->x;
    mat[index++] = vec->y;
    mat[index++] = vec->z;
    mat[index++] = 0.0f;
}

void multiplyMatM4(float *inmat1, float *inmat2,float *resMat)
{
    vSgemul(4, 4, 4, (vFloat *)inmat1, 'n', (vFloat *)inmat2, 'n', (vFloat *)resMat);
}

void transposeMatM4(float *mat)
{
    vSgetmi(4, (vFloat *)mat);
}