//
//  Scene.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Voxel.h"
#import "Camera.h"
#import "Chunk.h"
#import "MatrixStack.h"
#import "Region.h"

@interface Scene : NSObject
{
    NSTimer *animationTimer;
    
    GLuint _program;
    GLuint vertexBufferObject;
    GLuint vao;
    
    //Uniforms for mattrixes
    GLuint cameraToClipMatrixUnif;
    GLuint worldToCameraMatrixUnif;
    GLuint modelToWorldMatrixUnif;
    
    Camera *camera;
    MatrixStack *modelMatrix;
    
    Chunk *c;

    Region *r;
}

-(id)initWithBounds:(CGRect) newBounds;

-(void)startAnimating;
-(void)stopAnimating;
-(void)update;
-(void)render;

-(void)setupOpenGL;
-(void)didResizeTo:(CGRect)newBounds;

-(void)keyDown:(int)keyCode;
-(void)keyUp:(int)keyCode;

-(BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
-(BOOL)loadShaders;
-(BOOL)linkProgram:(GLuint)prog;
-(BOOL)validateProgram:(GLuint)prog;

@property CGRect bounds;
@end
