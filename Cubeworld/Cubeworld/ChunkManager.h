//
//  ChunkManager.h
//  Cubeworld
//
//  Created by Tom Jones on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chunk.h"

@interface ChunkManager : NSObject
{
    NSMutableArray *chunkStore;
}

-(Chunk *)chunkForPoint:(vec3 *)point;
@end
