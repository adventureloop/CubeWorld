//
//  Octnode.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Structures.h"

@interface Octnode : NSObject
{
//    id nodes[8];
    NSMutableArray *nodes;
    
    vec3 origin;
    colour colour;
    float size;
    int height;
    
    voxelData *voxelPtr;
    
    int blockType;
}

-(id)initWithTreeHeight:(unsigned int)nodeHeight nodeSize:(float)nodeSize orign:(vec3 *)nodeOrigin memoryPointer:(void *)mem;
-(void)createSubnodes;
-(void)addVoxelData;
-(void)calculateNewOrigin:(vec3 *)v1 OldOrigin:(vec3 *)v2 offsetVec:(vec3 *)offvec scale:(float) scale;

-(void)renderElements:(unsigned int *)elements offset:(unsigned int)offset;

-(int)numberOfVoxels;

-(void)updateColours:(colour *)newColour;

-(bool)collidesWithPoint:(vec3 *)point;
-(bool)updatePoint:(vec3 *)point withColour:(colour *)newColour;
-(void)updateType:(int)type;
-(bool)updatePoint:(vec3 *)point withBlockType:(int)type;
@end
