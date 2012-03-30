//
//  Generator.h
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"

@interface Generator : NSObject
{
}

-(ChunkLowMem *)chunkForPoint:(vec3 *)point;
-(ChunkLowMem *)chunkForX:(float)x Z:(float)z;
@end
