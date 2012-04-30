//
//  TimeCycle.m
//  Cubeworld
//
//  Created by Tom Jones on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeCycle.h"
#include <OpenGL/gl.h>

#define NOON 720
#define DAWN 360
#define SUNSET 1000
#define NIGHT 1120
#define DAY 480

#define MAX_LIGHT_INTENSITY 0.7
#define MAX_AMBIENT_INTENSITY 0.6

#define MIN_LIGHT_INTENSITY 0.3
#define MIN_AMBIENT_INTENSITY 0.2

#define MIN_PERCENT 0.2

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
        
        time = 360;
        
        [self update];
        [self render];
    }
    return self;
}

-(void)update
{
    NSLog(@"Time %f",time);
    if(time < DAWN || time > NIGHT) { //Night time
        float intensity;
        if(time > NOON)
            intensity = time / NOON;
        else 
            intensity = 1-((time - NOON)/NOON);            
        intensity = (intensity < MIN_PERCENT) ? MIN_PERCENT : intensity;
        
        lightDirecton.x = 0.3;
        lightDirecton.y = 1.0;
        
        lightIntensity.red = intensity * MIN_LIGHT_INTENSITY;
        lightIntensity.green = intensity * MIN_LIGHT_INTENSITY;
        lightIntensity.blue = intensity * MIN_LIGHT_INTENSITY;
        
        ambientIntensity.red = intensity * MIN_AMBIENT_INTENSITY;
        ambientIntensity.green = intensity * MIN_AMBIENT_INTENSITY;
        ambientIntensity.blue = intensity * MIN_AMBIENT_INTENSITY;
        
        return;
    } else if((time > DAWN && time < DAY )|| (time > SUNSET && time < NIGHT)){ //Sun rise low light
        lightDirecton.x = 0.3;
        lightDirecton.y = 1.0;
        
        lightIntensity.red = 0.3;
        lightIntensity.green = 0.3;
        lightIntensity.blue = 0.3;
        
        ambientIntensity.red = 0.3;
        ambientIntensity.green = 0.3;
        ambientIntensity.blue = 0.3;
        return;
    } else {                                //Must be day time
        float intensity;
        if(time > NOON)
            intensity = 1-((time - NOON)/NOON);
        else 
            intensity = time / NOON;
        intensity = (intensity < MIN_PERCENT) ? MIN_PERCENT : intensity;
        
        lightDirecton.x = (intensity < MIN_PERCENT) ? MIN_PERCENT : 1 - (intensity * 1.0);
        lightDirecton.y = 1.0;
        
        lightIntensity.red = intensity * MAX_LIGHT_INTENSITY;
        lightIntensity.green = intensity * MAX_LIGHT_INTENSITY;
        lightIntensity.blue = intensity * MAX_LIGHT_INTENSITY;
        
        ambientIntensity.red = intensity * MAX_AMBIENT_INTENSITY;
        ambientIntensity.green = intensity * MAX_AMBIENT_INTENSITY;
        ambientIntensity.blue = intensity * MAX_AMBIENT_INTENSITY;
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
    if(time+30 > 1440)
        time = 0;
    else 
        time += 30;
    [self update];
}

-(void)decreaseTime
{
    if(time-30 < 0)
        time = 1440;
    else 
        time -= 30;
    [self update];
}
@end
