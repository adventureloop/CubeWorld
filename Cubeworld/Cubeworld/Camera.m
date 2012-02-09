//
//  Camera.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"
#include <Accelerate/Accelerate.h>

@implementation Camera
-(id)init
{
    if(self = [super init]){
        cameraSpherePos = calloc( 3,sizeof(float));
        cameraTarget = calloc(3,sizeof(float));
        
        lookAtMatrix = calloc(16,sizeof(float));
    }
    return self;
}

-(void)dealloc
{
    free(cameraTarget);
    free(cameraSpherePos);
    free(lookAtMatrix);
}

-(void)update
{
    
}

-(void)resolveCameraPosition
{
  /*  float phi = degToRad(xPos);
    float theta = degToRad(yPos + 90.0f);
    
    float fSinTheta = sinf(theta);
	float fCosTheta = cosf(theta);
	float fCosPhi = cosf(phi);
	float fSinPhi = sinf(phi);
    
    float camPos[3];
    
    camPos[0] = fSinTheta * fCosPhi;
    camPos[1] = fCosTheta;
    camPos[2] = fSinTheta * fSinPhi;
    
    camPos[0] *= zPos;
    camPos[1] *= zPos;
    camPos[2] *= zPos;
    
    camPos[0] += camTargetV3[0];
    camPos[1] += camTargetV3[1];
    camPos[2] += camTargetV3[2];

    //CalcLookAtMatrix(camPos, g_camTarget, glm::vec3(0.0f, 1.0f, 0.0f)
    // CalcLookAtMatrix(const glm::vec3 &cameraPt, const glm::vec3 &lookPt, const glm::vec3 &upPt)    
    
	glm::vec3 lookDir = glm::normalize(lookPt - cameraPt);
	glm::vec3 upDir = glm::normalize(upPt);
    
	glm::vec3 rightDir = glm::normalize(glm::cross(lookDir, upDir));
	glm::vec3 perpUpDir = glm::cross(rightDir, lookDir);
    
	glm::mat4 rotMat(1.0f);
	rotMat[0] = glm::vec4(rightDir, 0.0f);
	rotMat[1] = glm::vec4(perpUpDir, 0.0f);
	rotMat[2] = glm::vec4(-lookDir, 0.0f);
    
	rotMat = glm::transpose(rotMat);
    
	glm::mat4 transMat(1.0f);
	transMat[3] = glm::vec4(-cameraPt, 1.0f);
    
	return rotMat * transMat;*/
}

float degToRad(float fAngDeg)
{
    const float fDegToRad = 3.14159f * 2.0f / 360.0f;
    return fAngDeg * fDegToRad;
}

float normalize(float *invec, float *outvec);
@end
