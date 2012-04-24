//
//  TimeCycle.m
//  Cubeworld
//
//  Created by Tom Jones on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeCycle.h"
#include <OpenGL/gl.h>

@implementation TimeCycle

-(id)init
{   
    if(self = [super init]) {
        resourceManager = [ResourceManager sharedResourceManager];
        
        program = [resourceManager getProgramLocation:@"Ambient"];
        
        lightIntensityUnif = glGetUniformLocation(program, "lightIntensity");
        ambientIntensityUnif = glGetUniformLocation(program, "ambientIntensity");
        dirToLightUnif = glGetUniformLocation(program, "lightDirection");
        
        lightDirecton.x = 0.5;
        lightDirecton.y = 0.9;
        lightDirecton.z = 0.0;
        
        lightIntensity.red = 0.8;
        lightIntensity.green = 0.8;
        lightIntensity.blue = 0.8;
        lightIntensity.alpha = 1.0;
        
        ambientIntensity.red = 0.5;
        ambientIntensity.green = 0.5;
        ambientIntensity.blue = 0.5;
        ambientIntensity.alpha = 1.0;
        
        time = 12;
        
        [self update];
        [self render];
    }
    return self;
}

-(void)update
{
    NSLog(@"Time %f",time);
    if(time < 6 || time > 18) { //Night time
        lightDirecton.x = 0.0;
        lightDirecton.y = 1.0;
        
        lightIntensity.red = 0.2;
        lightIntensity.green = 0.2;
        lightIntensity.blue = 0.2;
        
        ambientIntensity.red = 0.3;
        ambientIntensity.green = 0.3;
        ambientIntensity.blue = 0.3;
        
        return;
    } else if(time > 6){ //Sun rise low light
        lightDirecton.x = 1.0;
        lightDirecton.y = 1.0;
        
        lightIntensity.red = 0.6;
        lightIntensity.green = 0.6;
        lightIntensity.blue = 0.9;
        
        ambientIntensity.red = 0.5;
        ambientIntensity.green = 0.5;
        ambientIntensity.blue = 0.5;
        
        return;
    } else if (time > 11 || time < 14) {    //Noon
        lightDirecton.x = 1.0;
        lightDirecton.y = 1.0;
        
        lightIntensity.red = 0.8;
        lightIntensity.green = 0.8;
        lightIntensity.blue = 0.9;
        
        ambientIntensity.red = 0.6;
        ambientIntensity.green = 0.6;
        ambientIntensity.blue = 0.6;
    } else if(time > 14) {
        lightDirecton.x = -1.0;
        lightDirecton.y = 1.0;
        
        lightIntensity.red = 0.6;
        lightIntensity.green = 0.6;
        lightIntensity.blue = 0.7;
        
        ambientIntensity.red = 0.25;
        ambientIntensity.green = 0.25;
        ambientIntensity.blue = 0.25;
    }
}

-(void)render
{
    glUseProgram(program);
    
    glUniform4f(lightIntensityUnif,lightIntensity.red, lightIntensity.green, lightIntensity.blue, 1.0);
    glUniform4f(ambientIntensityUnif, ambientIntensity.red, ambientIntensity.green, ambientIntensity.blue, 1.0);
    glUniform3f(dirToLightUnif, lightDirecton.x, lightDirecton.y, lightDirecton.z);
    
    glUseProgram(0);
}

-(void)increaseTime
{
    if(time+3 > 24)
        time = 0;
    else 
        time += 3;
    [self update];
}

-(void)decreaseTime
{
    if(time-3 < 0)
        time = 24;
    else 
        time -= 3;
    [self update];
}
@end
