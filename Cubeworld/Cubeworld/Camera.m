//
//  Camera.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"
#include "VectorMath.h"

@implementation Camera
-(id)init
{
    if(self = [super init]){
        cameraPos = calloc( 3,sizeof(float));
        cameraTarget = calloc(3,sizeof(float));
        upVec = calloc(3, sizeof(float));
        
        lookAtMatrix = calloc(16,sizeof(float));
        perspectiveMatrix = calloc(16, sizeof(float));
        
        //Look at the origin
        cameraTarget[0] = 0.0f;
        cameraTarget[1] = 0.0f;
        cameraTarget[2] = -1.0f;
        
        cameraPos[0] = 0.0f;
        cameraPos[1] = 5.0f;
        cameraPos[2] = 1.0f;
        
        //The directio of up
        upVec[0] = 0.0f;
        upVec[1] = 1.0f;
        upVec[2] = 0.0f;
        
        //Set the lookAtMatrix to identity
        matrixDiagMatrixM4(lookAtMatrix, 1.0f);
        [self update];
        
        frustumScale = 2.4f;
        zNear = 0.5f; 
        zFar = 3.0f;
    }
    return self;
}

-(void)dealloc
{
    free(upVec);
    free(cameraTarget);
    free(cameraPos);
    free(lookAtMatrix);
    free(perspectiveMatrix);
    
    [super dealloc];
}

-(void)update
{
    [self resolveCameraPosition];
}

-(void)resolveCameraPosition
{
    //Look at eyePos, AtPos, UpVec
    float *zaxis = calloc(3, sizeof(float));
    float *xaxis = calloc(3,sizeof(float));
    float *yaxis = calloc(3,sizeof(float));
    
    //zaxis = normal(at - eye)
    subtractV3(cameraTarget, cameraPos, zaxis);
    normalizeV3(zaxis, zaxis);
    
    //xaxis = normal(cross(up,zaxis))
    crossV3(upVec, zaxis, xaxis);
    normalizeV3(xaxis, xaxis);
    
    //yaxis = cross(zaxis,xaxis)
    crossV3(zaxis, xaxis, yaxis);
    
    
    //Set lookAtMatrix to an identity Matrix
    matrixDiagMatrixM4(lookAtMatrix, 1.0);
    
    lookAtMatrix[0] = xaxis[0];
    lookAtMatrix[4] = xaxis[1];
    lookAtMatrix[8] = xaxis[2];
    lookAtMatrix[12] = -dotV3(xaxis,cameraTarget);
    
    lookAtMatrix[1] = yaxis[0];
    lookAtMatrix[5] = yaxis[1];
    lookAtMatrix[9] = yaxis[2];
    lookAtMatrix[13] = -dotV3(yaxis,cameraTarget);
    
    lookAtMatrix[2] = zaxis[0];
    lookAtMatrix[6] = zaxis[1];
    lookAtMatrix[10] = zaxis[2];
    lookAtMatrix[14] = -dotV3(zaxis,cameraTarget);
    
    //matrixLoadIdentity(lookAtMatrix);
    
    free(zaxis);
    free(xaxis);
    free(yaxis);
    
//    
//    //Calculate Position for the camera
//    float phi = degToRad(cameraSpherePos[0]);
//    float theta = degToRad(cameraSpherePos[1] + 90.0f);
//    
//    float fSinTheta = sinf(theta);
//	float fCosTheta = cosf(theta);
//	float fCosPhi = cosf(phi);
//	float fSinPhi = sinf(phi);
//    
//    float *camPos = calloc(3, sizeof(float));
//    
//    camPos[0] = fSinTheta * fCosPhi;
//    camPos[1] = fCosTheta;
//    camPos[2] = fSinTheta * fSinPhi;
//    
//    vecByScalarV3(camPos, cameraSpherePos[2], camPos);
//    
//    addV3(camPos, cameraTarget, camPos);
//
////    
//    camPos[0] = 0.0f;
//    camPos[1] = 0.0f;
//    camPos[2] = -1.0f;
//    
//    //Calculate Look At Matrix
//    float *lookDir = calloc(3, sizeof(float));
//    float *upDir = calloc(3, sizeof(float));
//    
//    subtractV3(cameraTarget, camPos, lookDir);
//    normalizeV3(lookDir, lookDir);
//    
//    normalizeV3(upVec, upDir);
//    
//    float *rightDir = calloc(3, sizeof(float));
//    float *perpUpDir = calloc(3, sizeof(float));
//    
//    crossV3(lookDir, upDir, rightDir);
//    normalizeV3(rightDir, rightDir);
//    
//    crossV3(rightDir, lookDir, perpUpDir);
//    
//    vecByScalarV3(lookDir, -1.0f, lookDir);
//    vecByScalarV3(camPos, -1.0f, camPos);
//    
//    float *rotMat = calloc(16,sizeof(float));
//    matrixDiagMatrixM4(rotMat, 1.0f);
//    
//    matrixSetVectorV3M4(rotMat, rightDir, 0);
//    matrixSetVectorV3M4(rotMat, perpUpDir, 4);
//    matrixSetVectorV3M4(rotMat, lookDir, 8);
//    
//    transposeMatM4(rotMat);
//    
//    float *transMat = calloc(16,sizeof(float));
//    
//    matrixDiagMatrixM4(transMat, 1.0f);
////    matrixSetVectorV3M4(transMat, camPos, 12);
//    
//    transMat[3] = camPos[0];
//    transMat[7] = camPos[1];
//    transMat[11] = camPos[2];
//    
//    multiplyMatM4(rotMat, transMat, lookAtMatrix);
//    
//    //Release the vectors and matracies used in the calculation
//    free(transMat);
//    free(rotMat);
//    free(camPos);
//    free(rightDir);
//    free(perpUpDir);
//    free(lookDir);
//    free(upDir);
}

-(void)resolvePerspectiveForWidth:(int)width Height:(int)height
{
	perspectiveMatrix[0] = frustumScale / (width / (float)height);
	perspectiveMatrix[5] = frustumScale;
	perspectiveMatrix[10] = (zFar + zNear) / (zNear - zFar);
	perspectiveMatrix[14] = (2 * zFar * zNear) / (zNear - zFar);
	perspectiveMatrix[11] = -1.0f;
}


-(float *)lookAtMatrix
{
    return lookAtMatrix;
}

-(float *)perspectiveMatrix
{
    return perspectiveMatrix;
}

#pragma mark Move the camera and camera target
-(void)moveCameraUp
{
    cameraPos[1] += 0.1;
}

-(void)moveCameraDown
{
    cameraPos[1] -= 0.1;
}

-(void)moveCameraLeft
{
    cameraPos[0] -= 0.1;
}

-(void)moveCameraRight
{
    cameraPos[0] += 0.1;
}

-(void)moveCameraForward
{
    cameraPos[2] += 0.1;
}

-(void)moveCameraBack
{
    cameraPos[2] -= 0.1;
}

-(void)moveCameraTargetUp
{
    cameraTarget[1] += 0.1;
}

-(void)moveCameraTargetDown
{
    cameraTarget[1] -= 0.1;
}

-(void)moveCameraTargetLeft
{
    cameraTarget[0] -= 0.1;
}

-(void)moveCameraTargetRight
{
    cameraTarget[0] += 0.1;
}

-(void)moveCameraTargetForward
{
    cameraTarget[2] += 0.1;
}

-(void)moveCameraTargetBack
{
    cameraTarget[2] -= 0.1;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Camera at (%f,%f,%f) looking at (%f,%f,%f)",cameraPos[0],cameraPos[1],cameraPos[2],
            cameraTarget[0],cameraTarget[1],cameraTarget[2]];
}
@end
