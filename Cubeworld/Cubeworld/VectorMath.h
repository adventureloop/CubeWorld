//
//  VectorMath.h
//  Cubeworld
//
//  Created by Tom Jones on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <Accelerate/Accelerate.h>

float degToRad(float);
float magnitudeV3(float *);
void normalizeV3(float *, float *);
void subtractV3(float *, float *, float *);

void crossV3(float *, float *, float *);
float dotV3(float *,float *);
void vecByScalarV3(float *,float scalar,float *);
void addV3(float *,float *invec2,float *);
void matrixDiagMatrixM4(float *,float);
void matrixLoadIdentity(float *);
void matrixSetAllToScalarM4(float *, float );
void matrixSetVectorV3M4(float *, float *, int );
void multiplyMatM4(float *, float *,float *);
void transposeMatM4(float *mat);

float degToRad(float fAngDeg)
{
    const float fDegToRad = 3.14159f * 2.0f / 360.0f;
    return fAngDeg * fDegToRad;
}

float magnitudeV3(float *invec)
{
    return sqrt( (invec[0] * invec[0]) + (invec[1] * invec[1]) + (invec[2] * invec[2]));
}

//Normalize invec, store result in outvec
void normalizeV3(float *invec, float *outvec)
{
    float len = magnitudeV3(invec);
    
    outvec[0] = invec[0] / len;
    outvec[1] = invec[1] / len;
    outvec[2] = invec[2] / len;
}

//Substract invec2 from invec1, store result in outvec

void subtractV3(float *invec1, float *invec2, float *outvec)
{
    outvec[0] = invec1[0] - invec2[0];
    outvec[1] = invec1[1] - invec2[1]; 
    outvec[2] = invec1[2] - invec2[2];
}


//Calculate the cross product of invec1 and invec2, store in outvec
void crossV3(float *invec1, float *invec2, float *outvec)
{
    outvec[0] = invec1[1] * invec2[2] - invec1[2] * invec2[1];
    outvec[1] = invec1[2] * invec2[0] - invec1[0] * invec2[2];
    outvec[2] = invec1[0] * invec2[1] - invec1[1] * invec2[0];
}

//Calculate the dot product of invec1 and invec2
float dotV3(float *invec1,float *invec2)
{
    return (invec1[0] * invec2[0]) + (invec1[1] * invec2[1]) + (invec1[2] * invec2[2]);
}

void vecByScalarV3(float *invec,float scalar,float *outvec)
{
	outvec[0] = invec[0] * scalar;   
	outvec[1] = invec[1] * scalar;   
	outvec[2] = invec[2] * scalar;   
}

void addV3(float *invec1,float *invec2,float *outvec)
{
	outvec[0] = invec1[0] + invec2[0];
	outvec[1] = invec1[1] + invec2[1];
	outvec[2] = invec1[2] + invec2[2];
    
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

void matrixSetVectorV3M4(float *mat, float *vec, int index)
{
    mat[index++] = vec[0];
    mat[index++] = vec[1];
    mat[index++] = vec[2];
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