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
        cameraSpherePos = calloc( 3,sizeof(float));
        cameraTarget = calloc(3,sizeof(float));
        upVec = calloc(3, sizeof(float));
        
        lookAtMatrix = calloc(16,sizeof(float));
        perspectiveMatrix = calloc(16, sizeof(float));
        
        cameraTarget[0] = 0.0f;
        cameraTarget[1] = 0.4f;
        cameraTarget[2] = 0.0f;
        
        cameraSpherePos[0] = 67.5f;
        cameraSpherePos[1] = -46.0f;
        cameraSpherePos[2] = 150.f;
        
        upVec[0] = 0.0f;
        upVec[1] = 1.0f;
        upVec[2] = 0.0f;
        
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
    free(cameraSpherePos);
    free(lookAtMatrix);
    free(perspectiveMatrix);
}

-(void)update
{
    [self resolveCameraPosition];
}

-(void)resolveCameraPosition
{
    
    //Calculate Position for the camera
    float phi = degToRad(cameraSpherePos[0]);
    float theta = degToRad(cameraSpherePos[1] + 90.0f);
    
    float fSinTheta = sinf(theta);
	float fCosTheta = cosf(theta);
	float fCosPhi = cosf(phi);
	float fSinPhi = sinf(phi);
    
    float *camPos = calloc(3, sizeof(float));
    
    camPos[0] = fSinTheta * fCosPhi;
    camPos[1] = fCosTheta;
    camPos[2] = fSinTheta * fSinPhi;
    
    vecByScalarV3(camPos, cameraSpherePos[2], camPos);
    
    addV3(camPos, cameraTarget, camPos);

    
    camPos[0] = 1.0f;
    camPos[1] = 1.0f;
    camPos[2] = 1.0f;
    
    //Calculate Look At Matrix
    float *lookDir = calloc(3, sizeof(float));
    float *upDir = calloc(3, sizeof(float));
    
    subtractV3(cameraTarget, camPos, lookDir);
    normalizeV3(lookDir, lookDir);
    
    normalizeV3(upVec, upDir);
    
    float *rightDir = calloc(3, sizeof(float));
    float *perpUpDir = calloc(3, sizeof(float));
    
    crossV3(lookDir, upDir, rightDir);
    normalizeV3(rightDir, rightDir);
    
    crossV3(rightDir, lookDir, perpUpDir);
    
    vecByScalarV3(lookDir, -1.0f, lookDir);
    vecByScalarV3(camPos, -1.0f, camPos);
    
    float *rotMat = calloc(16,sizeof(float));
    matrixDiagMatrixM4(rotMat, 1.0f);
    
    matrixSetVectorV3M4(rotMat, rightDir, 0);
    matrixSetVectorV3M4(rotMat, perpUpDir, 4);
    matrixSetVectorV3M4(rotMat, lookDir, 8);
    
    transposeMatM4(rotMat);
    
    float *transMat = calloc(16,sizeof(float));
    
    matrixDiagMatrixM4(transMat, 1.0f);
//    matrixSetVectorV3M4(transMat, camPos, 12);
    
    transMat[3] = camPos[0];
    transMat[7] = camPos[1];
    transMat[11] = camPos[2];
    
    multiplyMatM4(rotMat, transMat, lookAtMatrix);
    
    //Release the vectors and matracies used in the calculation
    free(transMat);
    free(rotMat);
    free(camPos);
    free(rightDir);
    free(perpUpDir);
    free(lookDir);
    free(upDir);
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

-(void)keyDown:(int)keyCode
{
    switch( keyCode ) {
        case 126:       // up arrow
            cameraTarget[1] += 0.1;
            break;
        case 125:       // down arrow
            cameraTarget[1] -= 0.1;
            break;
        case 124:       // right arrow
            cameraTarget[0] += 0.1;
            break;
        case 123:       // left arrow
            cameraTarget[0] -= 0.1;
            break;
            
            break;
        default:
            break;
            
    }
    NSLog(@"Looking at\t%fx,%fy,%fz",cameraTarget[0],cameraTarget[1],cameraTarget[2]);
}
@end
