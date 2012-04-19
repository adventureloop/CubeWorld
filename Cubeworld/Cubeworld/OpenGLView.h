//
//  OpenGLView.h
//  Cubeworld
//
//  Created by Tom Jones on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainScene.h"
#import "WorldScene.h"

@interface OpenGLView : NSOpenGLView
{
    MainScene *scene;
    BOOL captureMouse;
}

@end
