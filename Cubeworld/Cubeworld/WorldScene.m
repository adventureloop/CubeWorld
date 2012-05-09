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
    [camera setCameraPosition:[player entityLocation]];
    [camera setCameraRotations:[player playerRotation]];
    
    [camera update];
    
    //Clear the colour and depth buffers
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
    [r updateWithFocusPoint:[player entityLocation]];
    
    [r render];
    [s render];
    
    glUniform3f(transLocationUnif, 0.0, 0.0, 0.0);
    
//    [e render];
    
	glUseProgram(0);
    glSwapAPPLE();
}

-(void)setupOpenGL
{
    NSLog(@"Setting up world scene");
    
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glFrontFace(GL_CW);
    
    glEnable(GL_BLEND);
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
    [r setRenderDistance:1];
    s = [[SkyBox alloc]initWithSize:48];
    
    time = [[TimeCycle alloc]init];
    
    e = [[Entity alloc]initWithMesh:@"lowtest"];
    
    vec3 loc;
    loc.x = 0.0;
    loc.y = 25.0;
    loc.z = 0.0;
    
    player = [[PlayerEntity alloc]init];
    [player setLocation:&loc];
    
    mouse = YES;
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
            [player moveUp];
            break;
        case kVK_ANSI_Z:       
            [player moveDown];
            break;
        case kVK_ANSI_D:      
            [player moveRight];
            //[r moveX:1 Z:0];
            break;
        case kVK_ANSI_A:      
            [player moveLeft];
           // [r moveX:-1 Z:0];
            break;
        case kVK_ANSI_W:
            [player moveForward];
            //[r moveX:0 Z:-1];
            break;
        case kVK_ANSI_S:
            [player moveBackward];
           // [r moveX:0 Z:1];
            break;
            //Move the camera target
        case kVK_UpArrow:
            [player lookUp];
            break;
        case kVK_DownArrow:
            [player lookDown];
            break;
        case kVK_RightArrow:
            [player lookRight];
            break;
        case kVK_LeftArrow:
            [player lookLeft];
            break;
        case kVK_ANSI_Minus:
            [time decreaseTime];
            break;
        case kVK_ANSI_Equal:
            [time increaseTime];
            break;
        case kVK_ANSI_1:
            [r setRenderDistance:1];
            [s setSize:32];
            break;
        case kVK_ANSI_2:
            [r setRenderDistance:2];
            [s setSize:48];
            break;
        case kVK_ANSI_3:
            [r setRenderDistance:3];
            [s setSize:72];
        case kVK_ANSI_T:
            [camera setThirdPerson];
            break;
        case kVK_ANSI_F:
            [camera setFirstPerson];
            break;
        case kVK_ANSI_0:
            [r serialize];
            break;
        case kVK_ANSI_J:
            [s toggleFog];
            break;
        case kVK_ANSI_Q:
            mouse = -mouse;
            break; 
        default:
            break;
    }
}

-(void)keyUp:(int)keyCode
{
}

#pragma mark Mouse handling stuff
-(void)mouseMovedByX:(int)x Y:(int)y
{
    if(!mouse)
        return;
    if(x > 0)
        [player lookRight];
    else if(x < 0)
        [player lookLeft];
    
    if(y > 0)
        [player lookDown];
    else if(y < 0)
        [player lookUp];
}
@end
