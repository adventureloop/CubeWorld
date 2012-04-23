//
//  SceneLoader.h
//  Cubeworld
//
//  Created by Tom Jones on 28/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scene.h"
#import "ChunkManager.h"
#import "ResourceManager.h"

@interface SceneLoader : Scene
{
    ChunkManager *chunkManager;    
    ResourceManager *resourceManager;
    
    GLuint program;
    GLuint vertexArrayObject;
    
    GLuint vertexBufferObject;
    GLuint indexBufferObject;
    
    float *vertexData;
    unsigned int *indexArray;
    
    face *outlineBox;
    face *progressBox;
}
@end
