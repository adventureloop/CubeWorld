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
}

-(void)update;
-(void)resolveCameraPosition;
-(void)calculateLookAtMatrix;

-(void)multiplyVector1:(float *)v1 byVector2:(float *)v2 result:(float *)r1;
-(void)normaliseVector:(float *)v1;
-(void)subtractVector1:(float *)v1 vector2:(float *)v2;

-(void)multiplyMatrix1:(float *)m1 byMatrix2:(float *)m2 result:(float *)r2;

float degToRad(float);
@end
