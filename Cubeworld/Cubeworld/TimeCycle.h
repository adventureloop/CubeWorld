//
//  TimeCycle.h
//  Cubeworld
//
//  Created by Tom Jones on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceManager.h"

@interface TimeCycle : NSObject
{
    ResourceManager *resourceManager;
    
    GLuint program;
    
    GLuint lightIntensityUnif;
    GLuint ambientIntensityUnif;
    GLuint dirToLightUnif;
    
    vec3 lightDirecton;
    
    colour lightIntensity;
    colour ambientIntensity;
    
    float time;
}

-(void)update;
-(void)render;

-(void)increaseTime;
-(void)decreaseTime;
@end
