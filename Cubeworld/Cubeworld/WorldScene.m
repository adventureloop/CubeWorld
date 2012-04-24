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
        resourceManager = [ResourceManager sharedResourceManager];
        
        [self setBounds:newBounds];
        [self setupOpenGL];
    }
    return self;
}

-(void)render
{
    [camera update];
    
    //Clear the colour and depth buffers
    //glClearColor(0.85, 1.0, 1.0, 0.0);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClearDepth(1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [time render];
    
	glUseProgram(_program);
    
    //Set the camera matrix
    glUniformMatrix4fv(worldToCameraMatrixUnif, 1, GL_FALSE, [camera lookAtMatrix]);
    glUniformMatrix4fv(cameraToClipMatrixUnif, 1, GL_FALSE, [camera perspectiveMatrix]);
    
    //Use the model matrix(identity currently)
    glUniformMatrix4fv(modelToWorldMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
    
    //Draw the world region
    [r render];
    [s render];
//    
//    //Draw a camera indicator, though it doesnt look right to me.
//    glUseProgram(_program);
//    glUniform3f(transLocationUnif,0,0,0);
//    [cameraPosition render];
    
	glUseProgram(0);
    glSwapAPPLE();
}

-(void)setupOpenGL
{
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glFrontFace(GL_CW);
    
    glEnable(GL_BLEND);
    glEnable(GL_POLYGON_SMOOTH);
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
    
    //Get the program 
    _program = [resourceManager getProgramLocation:@"Ambient"];
    
	glUseProgram(_program);
    // Get uniform locations.
    cameraToClipMatrixUnif = glGetUniformLocation(_program, "cameraToClipMatrix");
    worldToCameraMatrixUnif = glGetUniformLocation(_program, "worldToCameraMatrix");
    modelToWorldMatrixUnif = glGetUniformLocation(_program, "modelToWorldMatrix");
    
    transLocationUnif = glGetUniformLocation(_program, "translation");

    lightIntensityUnif = glGetUniformLocation(_program, "lightIntensity");
    ambientIntensityUnif = glGetUniformLocation(_program, "ambientIntensity");
    dirToLightUnif = glGetUniformLocation(_program, "lightDirection");
    
    fogColourUnif = glGetUniformLocation(_program, "fogColour");
    fogNearUnif = glGetUniformLocation(_program, "fogNear");
    fogFarUnif = glGetUniformLocation(_program, "fogFar");
    
    
    //Initialise these values to ensure there is something useful in the shader
    glUniform4f(lightIntensityUnif,0.9, 0.9, 0.9, 1.0);
    glUniform4f(ambientIntensityUnif, 0.8, 0.8, 0.8, 1.0);
    glUniform3f(dirToLightUnif, 0.5, 0.9, 0.5);
    
    glUniform3f(fogColourUnif, 0.5, 0.5, 0.7);
    glUniform1f(fogFarUnif, 80);
    glUniform1f(fogNearUnif, 15);
    
	glUniformMatrix4fv(cameraToClipMatrixUnif, 1, GL_FALSE,[camera perspectiveMatrix]);
    glUniformMatrix4fv(worldToCameraMatrixUnif, 1, GL_FALSE,[camera lookAtMatrix]);
    glUniformMatrix4fv(modelToWorldMatrixUnif, 1, GL_FALSE, [modelMatrix mat]);
	glUseProgram(0);
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    
    r = [[Region alloc]initWithMatrixUnifLocation:modelToWorldMatrixUnif translationLocation:transLocationUnif program:_program];    
    s = [[SkyBox alloc]initWithSize:96];
    
    time = [[TimeCycle alloc]init];
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
            //[camera moveCameraRight];
            [r moveX:1 Z:0];
            break;
        case kVK_ANSI_A:      
            //[camera moveCameraLeft];
            [r moveX:-1 Z:0];
            break;
        case kVK_ANSI_W:
            //[camera moveCameraBack];
            [r moveX:0 Z:-1];
            break;
        case kVK_ANSI_S:
            //[camera moveCameraForward];
            [r moveX:0 Z:1];
            break;
            //Move the camera target
        case kVK_UpArrow:
            [camera moveCameraTargetUp];
           // [camera moveCameraUp];
            break;
        case kVK_DownArrow:
            [camera moveCameraTargetDown];
            //[camera moveCameraDown];
            break;
        case kVK_RightArrow:
            [camera moveCameraTargetRight];
            break;
        case kVK_LeftArrow:
            [camera moveCameraTargetLeft];
            break;
        case kVK_ANSI_Minus:
            [time decreaseTime];
            break;
        case kVK_ANSI_Equal:
            [time increaseTime];
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
//    if(x > 0)
//        [camera moveCameraTargetLeft];
//    else if(x < 0)
//        [camera moveCameraTargetRight];
//    
//    if(y > 0)
//        [camera moveCameraTargetUp];
//    else if(y < 0)
//        [camera moveCameraTargetDown];
}
@end
