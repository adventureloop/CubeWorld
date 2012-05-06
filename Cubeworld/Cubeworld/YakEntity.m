//
//  YakEntity.m
//  Cubeworld
//
//  Created by Tom Jones on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YakEntity.h"

@implementation YakEntity 
-(id)init
{
    if(self = [super initWithMesh:nil]) {
        if(renderEntity == nil) {
            NSLog(@"Yak:\tFailed to load mesh");
        }
    };
    return self;
}

-(void)render
{
    [renderEntity render];
}
@end
