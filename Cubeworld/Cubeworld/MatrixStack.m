//
//  MatrixStack.m
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixStack.h"
#import <OpenGL/gl.h>

@implementation MatrixStack
-(id)init
{
    if(self = [super init]) {
        //Build a stack of matrices
        for(int i = 0;i < 16;i++)
            stack[i] = calloc(16, sizeof(float));
        index = 0;
        mat = stack[index];
        
    }
    return self;
}

+(MatrixStack *)sharedMatrixStack
{
    static MatrixStack *shared;
    @synchronized(self)
    {
        if (!shared)
            shared = [[MatrixStack alloc] init];
        return shared;
    }
}

-(void)push
{
    if(++index > 15)
        index = 15;
    mat = stack[index];

    memcpy(stack[index], stack[index-1], 16 * sizeof(float));
}

-(void)pop
{
    if(--index < 0)
        index = 0;
    mat = stack[index];
}

-(void)dealloc
{
    for(int i =0; i < 16;i++)
        free(stack[i]);
    [super dealloc];
}
@end
