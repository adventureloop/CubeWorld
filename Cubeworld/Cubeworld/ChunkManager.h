//
//  ChunkManager.h
//  Cubeworld
//
//  Created by Tom Jones on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
#import "Generator.h"

@interface ChunkManager : NSObject
{
    NSMutableDictionary *chunkStore;
    Generator *generator;
    
    vec3 focusPoint;
}


-(ChunkLowMem *)chunkForX:(float)x Z:(float)z;
-(void)setFocusPoint:(vec3 *)point;
-(float)distanceBetweenA:(vec3 *)a B:(vec3 *)b;

@end
