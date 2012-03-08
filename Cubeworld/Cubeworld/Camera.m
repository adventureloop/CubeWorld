//
//  Camera.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"
#import "VectorMath.h"

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
        cameraTarget[2] = 0.0f;
        
        cameraPos[0] = 0.0f;
        cameraPos[1] = 0.0f;
        cameraPos[2] = -2.0f;
        
        //The directio of up
        upVec[0] = 0.0f;
        upVec[1] = 1.0f;
        upVec[2] = 0.0f;
        
        //Set the lookAtMatrix to identity
        lookAtMatrix = [[Matrix4 alloc]init];
        [lookAtMatrix loadIndentity];
        
        position.x = 0.0;
        position.y = 0.0;
        position.z = 0.0;
        
        angels.x = 0.0;
        angels.y = 0.0;
        angels.z = 0.0;
        
        [self update];
        
        frustumScale = 2.4f;
        zNear = 0.5f; 
        zFar = 100.0f;
        
        moveSpeed = 0.05;
    }
    return self;
}

-(void)dealloc
{
    free(upVec);
    free(cameraTarget);
    free(cameraPos);
//    free(lookAtMatrix);
    free(perspectiveMatrix);
    
    [super dealloc];
}

-(void)update
{
    [self resolveCameraPosition];
}

-(void)resolveCameraPosition
{
    [self bookCamera];
}

-(void)gooslingCamera
{
    [lookAtMatrix loadIndentity];
    [lookAtMatrix rotateByAngle:angels.y axisX:1.0f Y:0.0f Z:0.0f];
    [lookAtMatrix rotateByAngle:angels.x axisX:0.0f Y:1.0f Z:0.0f];
    
    vec3 playerPos;
    playerPos.x = -1 * position.x;
    playerPos.y = -1 * position.y;
    playerPos.z = -1 * position.z;
    
    [lookAtMatrix translateByVec3:&playerPos];
}

-(void)directXCamera
{
    float *mat = [lookAtMatrix mat];
    
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
    matrixDiagMatrixM4(mat, 1.0);
    
    mat[0] = xaxis[0];
    mat[4] = xaxis[1];
    mat[8] = xaxis[2];
    mat[12] = -dotV3(xaxis,cameraTarget);
    
    mat[1] = yaxis[0];
    mat[5] = yaxis[1];
    mat[9] = yaxis[2];
    mat[13] = -dotV3(yaxis,cameraTarget);
    
    mat[2] = zaxis[0];
    mat[6] = zaxis[1];
    mat[10] = zaxis[2];
    mat[14] = -dotV3(zaxis,cameraTarget);
    
    free(zaxis);
    free(xaxis);
    free(yaxis);
}

-(void)bookCamera
{    
    //Calculate Position for the camera
    float phi = degToRad(cameraPos[0]);
    float theta = degToRad(cameraPos[1] + 90.0f);
    
    float fSinTheta = sinf(theta);
	float fCosTheta = cosf(theta);
	float fCosPhi = cosf(phi);
	float fSinPhi = sinf(phi);
    
    float *camPos = calloc(3, sizeof(float));
    
    camPos[0] = fSinTheta * fCosPhi;
    camPos[1] = fCosTheta;
    camPos[2] = fSinTheta * fSinPhi;
    
    vecByScalarV3(camPos, cameraPos[2], camPos);
    
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
    
    float *mat = [lookAtMatrix mat];
    
    multiplyMatM4(rotMat, transMat, mat);
    
   // [lookAtMatrix loadIndentity];
    
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
    return [lookAtMatrix mat];
}

-(float *)perspectiveMatrix
{
    return perspectiveMatrix;
}

#pragma mark Move the camera and camera target
-(void)moveCameraUp
{
    cameraPos[1] += moveSpeed;
}

-(void)moveCameraDown
{
    cameraPos[1] -= moveSpeed;
}

-(void)moveCameraLeft
{
    cameraPos[0] -= moveSpeed;
//    cameraTarget[0] -= -moveSpeed;
}

-(void)moveCameraRight
{
    cameraPos[0] += moveSpeed;
//    cameraTarget[0] += -moveSpeed;
}

-(void)moveCameraForward
{
    cameraPos[2] += moveSpeed;
  //  cameraTarget[2] += moveSpeed;
}

-(void)moveCameraBack
{
    cameraPos[2] -= moveSpeed;
 //   cameraTarget[2] -= moveSpeed;
}

-(void)moveCameraTargetUp
{
    cameraTarget[1] += moveSpeed;
    angels.y += 1.0;
}

-(void)moveCameraTargetDown
{
    cameraTarget[1] -= moveSpeed;
    angels.y -= 1.0;
}

-(void)moveCameraTargetLeft
{
    cameraTarget[0] -= moveSpeed;
    angels.x -= moveSpeed;
}

-(void)moveCameraTargetRight
{
    cameraTarget[0] += moveSpeed;
    angels.x += moveSpeed;
}

-(void)moveCameraTargetForward
{
    cameraTarget[2] += moveSpeed;
}

-(void)moveCameraTargetBack
{
    cameraTarget[2] -= moveSpeed;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Camera at (%f,%f,%f) looking at (%f,%f,%f)",cameraPos[0],cameraPos[1],cameraPos[2],
            cameraTarget[0],cameraTarget[1],cameraTarget[2]];
    
//    return [NSString stringWithFormat:@"Camera at (%f,%f,%f) with angles (%f,%f,%f)",position.x,position.y,position.z,
//            angels.x,angels.y,angels.z];
}
@end
