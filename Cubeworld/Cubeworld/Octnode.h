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
    colour ncolour;
    float size;
    int height;
    
    voxelData *voxelPtr;
}

-(id)initWithTreeHeight:(int)nodeHeight nodeSize:(float)nodeSize orign:(vec4 *)nodeOrigin memoryPointer:(void *)mem;
-(void)createSubnodes;
-(void)addVoxelData;

-(void)calculateNewOrigin:(vec4 *)v1 OldOrigin:(vec4 *)v2 offsetVec:(vec4 *)offvec scale:(float) scale;
@end
