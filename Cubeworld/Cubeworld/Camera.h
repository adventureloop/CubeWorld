//
//  Camera.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "VectorMath.h"

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

-(float *)lookAtMatrix;
@end
