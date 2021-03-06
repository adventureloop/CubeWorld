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
        zNear = 1.0f; 
        zFar = 100.0f;
        
        //Look at the origin
        cameraTarget.x = 0.0f;
        cameraTarget.y = 90.0f;
        cameraTarget.z = 0.0f;
        
        cameraSpherePos.x = 85.0f;
        cameraSpherePos.y = -20.0f;
        cameraSpherePos.z = 38.0f;  //The diameter or distance to the target point.
        
        //The direction of up
        upVec.x = 0.0f;
        upVec.y = 1.0f;
        upVec.z = 0.0f;
        
        //Set the lookAtMatrix to identity
        lookAtMatrix = [[Matrix4 alloc]init];
        [lookAtMatrix loadIndentity];
        
        moveSpeed = 2.0;
        angleMoveSpeed = 5.0;
        
        [self setFirstPerson];
        
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
    if(firstPerson)
        [self firstPersonCamera];
    else 
        [self thirdPersonCamera];
}

-(void)firstPersonCamera
{    
    vec3 translate;
    translate.x = 0.0;
    translate.y = cameraPosition.y;
    translate.z = 0.0;
    
    [lookAtMatrix loadIndentity];
    
    [lookAtMatrix rotateYByAngle:cameraRotations.y];
    [lookAtMatrix rotateXByAngle:cameraRotations.x];
    
    [lookAtMatrix translateByVec3:&translate];
}

-(void)thirdPersonCamera
{    
    //Set values  for fix camera
    cameraTarget.x = 4.0f;
    cameraTarget.y = 15.0f;
    cameraTarget.z = 0.0f;
    
    cameraSpherePos.x = 95.0f;
    cameraSpherePos.y = -20.0f;
    cameraSpherePos.z = 38.0f;
    
    
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
    
    //Calculate Look At Matrix
    subtractV3(&cameraTarget,&camPos, &lookDir);  //Find the look direction vector and normalise
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
    
    //Release the vectors and matracies used in the calculation
    free(transMat);
    free(rotMat);
}

-(void)setThirdPerson
{
    thirdPerson = YES;
    firstPerson = NO;
    
    cameraTarget.x = 4.0f;
    cameraTarget.y = 15.0f;
    cameraTarget.z = 0.0f;
    
    cameraSpherePos.x = 95.0f;
    cameraSpherePos.y = -20.0f;
    cameraSpherePos.z = 38.0f;
}

-(void)setFirstPerson
{
    thirdPerson = NO;
    firstPerson = YES;
    
    cameraTarget.y = 0.0f;
    
    cameraSpherePos.x = 90.0;
    cameraSpherePos.y = 0.0;
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


-(void)setCameraPosition:(vec3 *)pos
{
    cameraPosition.x = -pos->x;
    cameraPosition.y = -pos->y;
    cameraPosition.z = -pos->z;
}

-(void)setCameraRotations:(vec3 *)rot
{
    cameraRotations.x = rot->x;
    cameraRotations.y = rot->y;
    cameraRotations.z = rot->z;
}

-(BOOL)firstPerson
{
    return firstPerson;
}

-(BOOL)thirdPerson
{
    return thirdPerson;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Camera at (%f,%f,%f) looking at (%f,%f,%f)",cameraSpherePos.x,cameraSpherePos.y,cameraSpherePos.z,
            cameraTarget.x,cameraTarget.y,cameraTarget.z];
}
@end
