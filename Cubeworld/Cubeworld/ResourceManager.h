//
//  ResourceManager.h
//  Cubeworld
//
//  Created by Tom Jones on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
#import "RenderEntity.h"

#include <OpenGL/gl.h>

#define MAX_PROGRAMS 16

@interface ResourceManager : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary *programs;
    NSMutableDictionary *meshes;
    
    NSString *path;
    NSString *resourcepath;

    NSString *world;
    NSXMLParser *parser;

    id result;
}
-(GLuint)loadShaders:(NSString *)name;
-(GLuint)getProgramLocation:(NSString *)name;
+(ResourceManager *)sharedResourceManager;

-(void)storeChunk:(ChunkLowMem *)chunk;
-(ChunkLowMem *)getChunkForXZ:(NSString *)chunk;
-(RenderEntity *)renderEntityForString:(NSString *)name;

-(BOOL)chunkExistsForString:(NSString *)chunk;
-(BOOL)fileExistsForString:(NSString *)file;

-(void)parseFileForString:(NSString *)filePath;
@end
