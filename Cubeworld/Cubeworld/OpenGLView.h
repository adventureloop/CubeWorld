//
//  OpenGLView.h
//  Cubeworld
//
//  Created by Tom Jones on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenGLView : NSOpenGLView
{
    NSTimer *animationTimer;
    
    GLuint _program;
    GLuint vertexBufferObject;
    GLuint vao;
    
    float offsetX;
    float offsetY;
    float offsetZ;
    
    //Uniforms
    GLuint offsetUniform;
    GLuint perspectiveMatrixUnif;
    
    float theMatrix[16];
    float fFrustumScale;
    float fzNear; 
    float fzFar;
}

-(void)setupOpenGL;

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)loadShaders;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

-(void)render;

@end
