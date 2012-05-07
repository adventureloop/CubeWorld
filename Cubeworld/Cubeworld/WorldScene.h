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
#import "ChunkLowMem.h"
#import "MatrixStack.h"
#import "Region.h"
#import "Scene.h"
#import "ResourceManager.h"
#import "SkyBox.h"
#import "TimeCycle.h"
#import "Entity.h"


/*!
 * @abstract World Scene, creates and manages a scene with a single region.
 */
@interface WorldScene : Scene
{
    ResourceManager *resourceManager;
    GLuint _program;
    
    //Uniforms for mattrixes
    GLuint cameraToClipMatrixUnif;
    GLuint worldToCameraMatrixUnif;
    GLuint modelToWorldMatrixUnif;
    
    GLuint transLocationUnif;
    
    GLuint lightIntensityUnif;
    GLuint ambientIntensityUnif;
    GLuint dirToLightUnif;
    
    GLuint fogColourUnif;
    GLuint fogNearUnif;
    GLuint fogFarUnif;
    
    Camera *camera;
    MatrixStack *modelMatrix;

    ChunkLowMem *cameraPosition;
    TimeCycle *time;
    
    Region *r;
    SkyBox *s;
    Entity *e;
    
    BOOL mouse;
}
@end
