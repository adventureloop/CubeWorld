//
//  ResourceManager.h
//  Cubeworld
//
//  Created by Tom Jones on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
#include <OpenGL/gl.h>

#define MAX_PROGRAMS 16

@interface ResourceManager : NSObject
{
    NSMutableDictionary *programs;

}

//-(BOOL)chunkExistsFor:(float)x Z:(float)z;
//-(ChunkLowMem *)loadChunkForX:(float)x Z:(float)z;

-(GLuint)loadShaders:(NSString *)name;
-(GLuint)getProgramLocation:(NSString *)name;
+(ResourceManager *)sharedResourceManager;
@end
