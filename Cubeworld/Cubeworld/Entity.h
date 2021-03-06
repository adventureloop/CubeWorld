//
//  Entity.h
//  Cubeworld
//
//  Created by Tom Jones on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceManager.h"
#import "RenderEntity.h"
#import "ChunkLowMem.h"

/*!
 * @abstract Handles the Management an Entities logic
 */
@interface Entity : NSObject
{
    GLuint program;
    ResourceManager *resourceManager;
    
    GLuint transLocationUnif;
    
    RenderEntity *renderEntity;
    ChunkLowMem *chunk;
    
    vec3 location;  //Location within the world
}

-(id)initWithMesh:(NSString *)mesh;

-(void)updateWithDelta:(NSTimeInterval)delta;
-(void)render;
-(BOOL)collidesWithPoint:(vec3 *)point;

-(void)setChunk:(ChunkLowMem *)achunk;

-(vec3 *)entityLocation;
-(void)setLocation:(vec3 *)newLocation;
@end
