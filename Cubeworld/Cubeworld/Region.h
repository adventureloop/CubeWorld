//
//  Region.h
//  Cubeworld
//
//  Created by Tom Jones on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
#import "ChunkManager.h"
#import "MatrixStack.h"
#import <OpenGL/gl.h>
#import "ChunkManager.h"

@interface Region : NSObject
{
    NSMutableArray *chunks;
    
    ChunkManager *chunkManager;
    vec3 focusPoint;
    
    MatrixStack *modelMatrix;
    
    GLuint _program;
    GLuint modelMatrixUnif;
    GLuint transLationUnif;
}
-(id)initWithMatrixUnifLocation:(GLuint) unifLocation translationLocation:(GLuint) transLoc program:(GLuint) programLocation;
-(void)render;
-(void)updateWithFocusPoint:(vec3 *)point;
@end
