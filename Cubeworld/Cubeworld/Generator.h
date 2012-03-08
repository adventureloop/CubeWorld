//
//  Generator.h
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chunk.h"

@interface Generator : NSObject
{
}

-(Chunk *)chunkForPoint:(vec3 *)point;
-(Chunk *)chunkForX:(float)x Z:(float)z;
@end
