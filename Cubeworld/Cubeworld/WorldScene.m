//
//  Scene.m
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldScene.h"


@implementation WorldScene
@synthesize bounds;

-(id)initWithBounds:(CGRect)newBounds
{
    if(self = [super init]) {
        [self setBounds:newBounds];
        [self setupOpenGL];
    }
    return self;
}

-(void)render
{
//    if(_program == 0)
//        [self setupOpenGL];
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
    glUniformMatrix4fv(modelToWorldMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
    
    [r render];
//    
//    glUniform3f(transLocationUnif,1,1,1);
//    
//    [cameraPosition render];
    
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
    
    modelMatrix = [MatrixStack sharedMatrixStack];
    [modelMatrix loadIndentity];
    
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
    glUniformMatrix4fv(worldToCameraMatrixUnif, 1, GL_FALSE,[camera lookAtMatrix]);
    glUniformMatrix4fv(modelToWorldMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
	glUseProgram(0);
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    
    r = [[Region alloc]initWithMatrixUnifLocation:modelToWorldMatrixUnif translationLocation:transLocationUnif program:_program];
    cameraPosition = [[Voxel alloc]init];
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
    NSBundle *bundle = [NSBundle mainBundle];
    vertShaderPathname = [bundle  pathForResource:@"Ambient" ofType:@"vsh"];
    
    
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Ambient" ofType:@"fsh"];
    
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
    
    cameraToClipMatrixUnif = glGetUniformLocation(_program, "cameraToClipMatrix");
    worldToCameraMatrixUnif = glGetUniformLocation(_program, "worldToCameraMatrix");
    modelToWorldMatrixUnif = glGetUniformLocation(_program, "modelToWorldMatrix");
    
    transLocationUnif = glGetUniformLocation(_program, "translation");
    
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

#pragma mark Handle key presses
-(void)keyDown:(int)keyCode
{
    switch( keyCode ) {
        case kVK_Space:       
            [camera moveCameraUp];
            break;
        case kVK_ANSI_Z:       
            [camera moveCameraDown];
            break;
        case kVK_ANSI_D:      
            [camera moveCameraRight];
            break;
        case kVK_ANSI_A:      
            [camera moveCameraLeft];
            break;
        case kVK_ANSI_W:
            [camera moveCameraForward];
            break;
        case kVK_ANSI_S:
            [camera moveCameraBack];
            
            //Move the camera target
        case kVK_UpArrow:
            [camera moveCameraTargetUp];
            break;
        case kVK_DownArrow:
            [camera moveCameraTargetDown];
            break;
        case kVK_RightArrow:
            [camera moveCameraTargetRight];
            break;
        case kVK_LeftArrow:
            [camera moveCameraTargetLeft];
            break;
        default:
            break;
    }
    NSLog(@"%@",[camera description]);
}

-(void)keyUp:(int)keyCode
{
}

#pragma mark Mouse handling stuff
-(void)mouseMovedByX:(int)x Y:(int)y
{
    if(x > 0)
        [camera moveCameraTargetLeft];
    else if(x < 0)
        [camera moveCameraTargetRight];
    
    if(y > 0)
        [camera moveCameraTargetUp];
    else if(y < 0)
        [camera moveCameraTargetDown];
}
@end
