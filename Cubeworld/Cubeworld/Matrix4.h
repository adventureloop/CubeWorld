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
-(void)translateByVec4:(Vector4 *)vec;
-(void)uniformScale:(float) scale;
-(void)rotateByVec4:(Vector4 *)vec;
@end
