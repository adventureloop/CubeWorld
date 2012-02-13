//
//  Camera.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Camera : NSObject
{
    float *cameraSpherePos;
    float *cameraTarget;
    float *upVec;
    
    float *lookAtMatrix;
    float *perspectiveMatrix;
    
    float frustumScale;
    float zFar;
    float zNear;
}

-(void)update;
-(void)resolveCameraPosition;
-(void)resolvePerspectiveForWidth:(int)width Height:(int)height;

-(float *)lookAtMatrix;
-(float *)perspectiveMatrix;

-(void)keyDown:(int)keyCode;
@end
