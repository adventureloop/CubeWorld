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
        perspectiveMatrix = calloc(16, sizeof(float));
        
        frustumScale = 2.4f;
        zNear = 0.5f; 
        zFar = 100.0f;
        
        //Look at the origin
        cameraTarget.x = 0.0f;
        cameraTarget.y = 10.0f;
        cameraTarget.z = -5.0f;
        
        cameraSpherePos.x = 87.0f;
        cameraSpherePos.y = -20.0f;
        cameraSpherePos.z = 66.0f;
        
        //The directio of up
        upVec.x = 0.0f;
        upVec.y = 1.0f;
        upVec.z = 0.0f;
        
        //Set the lookAtMatrix to identity
        lookAtMatrix = [[Matrix4 alloc]init];
        [lookAtMatrix loadIndentity];
        
        moveSpeed = 5.0;
        angleMoveSpeed = 1.0;
        
        [self update];
    }
    return self;
}

-(void)dealloc
{
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

//-(void)directXCamera
//{
//    float *mat = [lookAtMatrix mat];
//    
//    //Look at eyePos, AtPos, UpVec
//    float *zaxis = calloc(3, sizeof(float));
//    float *xaxis = calloc(3,sizeof(float));
//    float *yaxis = calloc(3,sizeof(float));
//    
//    //zaxis = normal(at - eye)
//    subtractV3(&cameraTarget, cameraSpherePos, zaxis);
//    normalizeV3(zaxis, zaxis);
//    
//    //xaxis = normal(cross(up,zaxis))
//    crossV3(upVec, zaxis, xaxis);
//    normalizeV3(xaxis, xaxis);
//    
//    //yaxis = cross(zaxis,xaxis)
//    crossV3(zaxis, xaxis, yaxis);
//    
//    
//    //Set lookAtMatrix to an identity Matrix
//    matrixDiagMatrixM4(mat, 1.0);
//    
//    mat[0] = xaxis[0];
//    mat[4] = xaxis[1];
//    mat[8] = xaxis[2];
//    mat[12] = -dotV3(xaxis,cameraTarget);
//    
//    mat[1] = yaxis[0];
//    mat[5] = yaxis[1];
//    mat[9] = yaxis[2];
//    mat[13] = -dotV3(yaxis,cameraTarget);
//    
//    mat[2] = zaxis[0];
//    mat[6] = zaxis[1];
//    mat[10] = zaxis[2];
//    mat[14] = -dotV3(zaxis,cameraTarget);
//    
//    free(zaxis);
//    free(xaxis);
//    free(yaxis);
//}

-(void)bookCamera
{    
    //Calculate Position for the camera
    float phi = degToRad(cameraSpherePos.x);
    float theta = degToRad(cameraSpherePos.y + 90.0f);
    
    float fSinTheta = sinf(theta);
	float fCosTheta = cosf(theta);
	float fCosPhi = cosf(phi);
	float fSinPhi = sinf(phi);
    
    vec3 camPos;
    
    vec3 lookDir;
    vec3 upDir;
    
    vec3 rightDir;
    vec3 perpUpDir;
    
    camPos.x = fSinTheta * fCosPhi;
    camPos.y = fCosTheta;
    camPos.z = fSinTheta * fSinPhi;
    
    vecByScalarV3(&camPos, cameraSpherePos.z, &camPos);
    
    addV3(&camPos, &cameraTarget, &camPos);
    
    
    //The following code is an indightment of our justice system
//    camPos.x = cameraSpherePos.x;
//    camPos.y = cameraSpherePos.y;
//    camPos.z = cameraSpherePos.z;
    
    //Calculate Look At Matrix
    subtractV3(&cameraTarget, &camPos, &lookDir);
    normalizeV3(&lookDir, &lookDir);
    
    normalizeV3(&upVec, &upDir);
    
    crossV3(&lookDir, &upDir, &rightDir);
    normalizeV3(&rightDir, &rightDir);
    
    crossV3(&rightDir, &lookDir, &perpUpDir);
    
    vecByScalarV3(&lookDir, -1.0f, &lookDir);
    
    
    float *rotMat = calloc(16,sizeof(float));
    matrixLoadIdentity(rotMat);
    
    matrixSetVectorV3M4(rotMat, &rightDir, 0);
    matrixSetVectorV3M4(rotMat, &perpUpDir, 1);
    
    vecByScalarV3(&camPos, -1.0f, &camPos);
    matrixSetVectorV3M4(rotMat, &lookDir, 2);
    
    transposeMatM4(rotMat);
    
    float *transMat = calloc(16,sizeof(float));
    
    matrixLoadIdentity(transMat);
    matrixSetVectorV3M4(transMat, &camPos, 3);
    
    float *mat = [lookAtMatrix mat];
    
    multiplyMatM4(rotMat, transMat, mat);
    
   // [lookAtMatrix loadIndentity];
    
    //Release the vectors and matracies used in the calculation
    free(transMat);
    free(rotMat);
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
    cameraTarget.x += moveSpeed;
}

-(void)moveCameraDown
{
    cameraTarget.y -= moveSpeed;
}

-(void)moveCameraLeft
{
    cameraTarget.x -= moveSpeed;
}

-(void)moveCameraRight
{
    cameraTarget.x += moveSpeed;
}

-(void)moveCameraForward
{
    cameraTarget.z += moveSpeed;
}

-(void)moveCameraBack
{
    cameraTarget.z -= moveSpeed;
}

-(void)moveCameraTargetUp
{
    cameraSpherePos.y += angleMoveSpeed;
}

-(void)moveCameraTargetDown
{
    cameraSpherePos.y -= angleMoveSpeed;
}

-(void)moveCameraTargetLeft
{
    cameraSpherePos.x -= angleMoveSpeed;
}

-(void)moveCameraTargetRight
{
    cameraSpherePos.x += angleMoveSpeed;
}

-(void)moveCameraTargetForward
{
    cameraSpherePos.x += angleMoveSpeed;
}

-(void)moveCameraTargetBack
{
    cameraSpherePos.z -= angleMoveSpeed;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Camera at (%f,%f,%f) looking at (%f,%f,%f)",cameraSpherePos.x,cameraSpherePos.y,cameraSpherePos.z,
            cameraTarget.x,cameraTarget.y,cameraTarget.z];
    
//    return [NSString stringWithFormat:@"Camera at (%f,%f,%f) with angles (%f,%f,%f)",position.x,position.y,position.z,
//            angels.x,angels.y,angels.z];
}
@end
