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
        position.z = -2.0;
        
        angles.x = 0.0;
        angles.y = 90.0;
        angles.z = 0.0;
        
        [self update];
        
        frustumScale = 2.4f;
        zNear = 0.5f; 
        zFar = 100.0f;
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
    [self directXCamera];
    [self erikCamera];
}

-(void)erikCamera
{
    [lookAtMatrix loadIndentity];
    [lookAtMatrix rotateByAngle:angles.y axisX:1.0f Y:0.0f Z:0.0f];
    [lookAtMatrix rotateByAngle:angles.x axisX:0.0f Y:1.0f Z:0.0f];
    
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
    cameraPos[1] += 0.1;
    cameraTarget[1] += -0.1;
}

-(void)moveCameraDown
{
    cameraPos[1] -= 0.1;
    cameraTarget[1] -= -0.1;
}

-(void)moveCameraLeft
{
    cameraPos[0] -= 0.1;
    cameraTarget[0] -= -0.1;
}

-(void)moveCameraRight
{
    cameraPos[0] += 0.1;
    cameraTarget[0] += -0.1;
}

-(void)moveCameraForward
{
    cameraPos[2] += 0.1;
    cameraTarget[2] += 0.1;
}

-(void)moveCameraBack
{
    cameraPos[2] -= 0.1;
    cameraTarget[2] -= 0.1;
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
