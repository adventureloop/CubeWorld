//
//  Matrix4.h
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector4.h"

@interface Matrix4 : NSObject
{
    float *mat;
}

-(float *)mat;

-(void)transpose;
-(void)translateByVec3:(vec3 *)vec;
-(void)uniformScale:(float) scale;

-(void)rotateXByAngle:(float)angle;
-(void)rotateYByAngle:(float)angle;
-(void)rotateZByAngle:(float)angle;

-(void)loadIndentity;
@end
