//
//  MatrixStack.h
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Matrix4.h"

@interface MatrixStack : Matrix4
{
    float *stack[16];
    int index;
}

-(void)push;
-(void)pop;

+(MatrixStack *)sharedMatrixStack;
@end
