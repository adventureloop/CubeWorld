//
//  Scene.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scene : NSObject
{
    NSTimer *updateTimer;
    NSTimer *renderTimer;
}

-(void)startAnimating;
-(void)stopAnimating;
-(void)update;
-(void)render;
@end
