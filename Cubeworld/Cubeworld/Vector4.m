//
//  Vector4.m
//  Cubeworld
//
//  Created by Tom Jones on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Vector4.h"

@implementation Vector4
-(id)init
{
    if(self = [super init])
        vec = calloc(1, sizeof(vec4));
    return self;
}

-(vec4 *)vec
{
    return vec;
}

-(void)dealloc
{
    free(vec);
    
    [super dealloc];
}
@end
