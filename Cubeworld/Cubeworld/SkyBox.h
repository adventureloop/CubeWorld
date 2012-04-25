//
//  SkyBox.h
//  Cubeworld
//
//  Created by Tom Jones on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OctnodeLowMem.h"
#import "Structures.h"
#import "ResourceManager.h"

@interface SkyBox : NSObject
{
    GLuint program;
    ResourceManager *resourceManager;
    
    GLuint vertexBufferObject;
    GLuint vertexArrayObject;
    GLuint indexBufferObject;
 
    GLuint transLocationUnif;
    GLuint modelMatrixUnif;
    
    GLuint fogColourUnif;
    GLuint fogNearUnif;
    GLuint fogFarUnif;
    
    float *vertexData;
    unsigned int *indexArray;
    float size;
    OctnodeLowMem *box;
    
    colour fogColour;
    float fogNear;
    float fogFar;
}

-(id)initWithSize:(float)asize;
-(void)render;
-(void)setSize:(float)size;
@end
