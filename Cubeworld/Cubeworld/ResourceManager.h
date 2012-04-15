//
//  ResourceManager.h
//  Cubeworld
//
//  Created by Tom Jones on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
@interface ResourceManager : NSObject
{
}

-(BOOL)chunkExistsFor:(float)x Z:(float)z;
-(ChunkLowMem *)loadChunkForX:(float)x Z:(float)z;
@end
