//
//  Scene.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Scene.h"
#include <OpenGL/gl.h>

@implementation Scene
@synthesize bounds;

-(void)startAnimating
{
}

-(void)stopAnimating;
{
}

-(void)update
{
}

-(void)render
{
    if(_program == 0)
        [self setupOpenGL];
    [camera update];
    
    //Clear the colour and depth buffers
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClearDepth(1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	glUseProgram(_program);
    
    //Set the camera matrix
    glUniformMatrix4fv(worldToCameraMatrixUnif, 1, GL_FALSE, [camera lookAtMatrix]);
    glUniformMatrix4fv(cameraToClipMatrixUnif, 1, GL_FALSE, [camera perspectiveMatrix]);
    
    //Use the model matrix(identity currently)
    glUniformMatrix4fv(modelToWorldMatrixUnif, 1, GL_FALSE, modelToWorldMatrix);
    
    [c render];
    
	glUseProgram(0);
    glSwapAPPLE();
}

-(void)setupOpenGL
{
    [self loadShaders];   
    
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glFrontFace(GL_CW);
    
    camera = [[Camera alloc]init];
    
    modelToWorldMatrix = calloc(16,sizeof(float));
    modelToWorldMatrix[0] = 1.0f;
    modelToWorldMatrix[5] = 1.0f;
    modelToWorldMatrix[10] = 1.0f;
    modelToWorldMatrix[15] = 1.0f;
    
    //Enable depth testing
    glEnable(GL_DEPTH_TEST);
    glDepthMask(GL_TRUE);
    glDepthFunc(GL_LEQUAL);
    glDepthRange(0.0f, 1.0f);
    
    //Manage the aspect ratio and window scale
    int w = [self bounds ].size.width;
    int h = [self bounds ].size.height;
    
    [camera resolvePerspectiveForWidth:w Height:h];
    
	glUseProgram(_program);
	glUniformMatrix4fv(cameraToClipMatrixUnif, 1, GL_FALSE,[camera perspectiveMatrix]);
	glUseProgram(0);
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    
    v1 = [[Voxel alloc]init];
    v2 = [[Voxel alloc]init];
    
    c = [[Chunk alloc]init];
    
    self->animationTimer = [NSTimer scheduledTimerWithTimeInterval:1/30 target:self selector:@selector(render) userInfo:nil repeats:YES];
}

-(void)didResizeTo:(CGRect)newBounds
{
    [self setBounds:newBounds];
    
    int w = [self bounds].size.width;
    int h = [self bounds].size.height;
    
    [camera resolvePerspectiveForWidth:w Height:h];
    
	glUseProgram(_program);
	glUniformMatrix4fv(cameraToClipMatrixUnif, 1, GL_FALSE,[camera perspectiveMatrix]);
	glUseProgram(0);
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
}


#pragma mark -  OpenGL ES 2 shader compilation
- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"vsh"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    vertShaderPathname = [bundle  pathForResource:@"Test" ofType:@"vsh"];
    
    
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    /*glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
     glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");*/
    
    glBindAttribLocation(_program, 0, "position");
    glBindAttribLocation(_program, 1, "inColor");
    glBindAttribLocation(_program, 2, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    /* uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
     uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");*/
    cameraToClipMatrixUnif = glGetUniformLocation(_program, "cameraToClipMatrix");
    worldToCameraMatrixUnif = glGetUniformLocation(_program, "worldToClipMatrix");
    modelToWorldMatrixUnif = glGetUniformLocation(_program, "modelToWorldMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}


- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}


- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
@end
