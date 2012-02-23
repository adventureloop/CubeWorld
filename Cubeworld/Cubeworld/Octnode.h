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
    
    vec4 origin;
    colour colour;
    float size;
    int height;
    
    voxelData *voxelPtr;
}

-(id)initWithTreeHeight:(unsigned int)nodeHeight nodeSize:(float)nodeSize orign:(vec4 *)nodeOrigin memoryPointer:(void *)mem;
-(void)createSubnodes;
-(void)addVoxelData;
-(void)calculateNewOrigin:(vec4 *)v1 OldOrigin:(vec4 *)v2 offsetVec:(vec4 *)offvec scale:(float) scale;

-(void)renderElements:(unsigned int *)elements offset:(unsigned int)offset;

-(int)numberOfVoxels;

-(void)updateColours:(colour *)newColour;

-(bool)collidesWithPoint:(vec4 *)point;
@end
