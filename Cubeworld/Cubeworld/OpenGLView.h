//
//  OpenGLView.h
//  Cubeworld
//
//  Created by Tom Jones on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Voxel.h"
#import "Camera.h"
#import "Chunk.h"


@interface OpenGLView : NSOpenGLView
{
    NSTimer *animationTimer;
    
    GLuint _program;
    GLuint vertexBufferObject;
    GLuint vao;
    
    float offsetX;
    float offsetY;
    float offsetZ;
    
    //Uniforms for mattrixes
    GLuint cameraToClipMatrixUnif;
    GLuint worldToCameraMatrixUnif;
    GLuint modelToWorldMatrixUnif;
    
    float *cameraToClipMatrix;
    float *worldToCameraMatrix;
    float *modelToWorldMatrix;
    
    float fFrustumScale;
    float fzNear; 
    float fzFar;
    
    Voxel *v1;
    Voxel *v2;
    
    Camera *camera;
    
    Chunk *c;
}

-(void)setupOpenGL;

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)loadShaders;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

-(void)render;

@end
