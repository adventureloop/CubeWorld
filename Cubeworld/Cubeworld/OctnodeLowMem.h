//
//  Octnode.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Structures.h"
#import "ChunkLowMem.h"

@interface OctnodeLowMem : NSObject
{
    NSMutableArray *nodes;
    
    vec3 origin;
    colour colour;
    float size;
    int height;
    
    voxelData *voxelPtr;
    int indexOffset;
    id *datasource;
    
    int blockType;
}

-(id)initWithTreeHeight:(unsigned int)nodeHeight nodeSize:(float)nodeSize orign:(vec3 *)nodeOrigin dataSource:(id *)ndatasource;
-(void)createSubnodes;
-(void)addVoxelData;
-(void)calculateNewOrigin:(vec3 *)v1 OldOrigin:(vec3 *)v2 offsetVec:(vec3 *)offvec scale:(float) scale;

-(void)renderElements:(unsigned int *)elements;

-(int)numberOfVoxels;

-(void)updateColours:(colour *)newColour;

-(bool)collidesWithPoint:(vec3 *)point;
-(bool)updatePoint:(vec3 *)point withColour:(colour *)newColour;
-(void)updateType:(int)type;
-(bool)updatePoint:(vec3 *)point withBlockType:(int)type;

-(int)typeForPoint:(vec3 *)point;

-(vec3 *)origin;
@end
