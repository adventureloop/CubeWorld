//
//  Camera.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix4.h"

@interface Camera : NSObject
{
    float *cameraPos;
    float *cameraTarget;
    float *upVec;
    
    Matrix4 *lookAtMatrix;
    float *perspectiveMatrix;
    
    float frustumScale;
    float zFar;
    float zNear;
    
    vec3 position;
    vec3 angles;        
}

-(void)update;
-(void)resolveCameraPosition;
-(void)resolvePerspectiveForWidth:(int)width Height:(int)height;

-(float *)lookAtMatrix;
-(float *)perspectiveMatrix;

-(void)directXCamera;
-(void)erikCamera;

-(void)moveCameraUp;
-(void)moveCameraDown;
-(void)moveCameraLeft;
-(void)moveCameraRight;
-(void)moveCameraForward;
-(void)moveCameraBack;

-(void)moveCameraTargetUp;
-(void)moveCameraTargetDown;
-(void)moveCameraTargetLeft;
-(void)moveCameraTargetRight;
-(void)moveCameraTargetForward;
-(void)moveCameraTargetBack;
@end
