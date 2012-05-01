//
//  ResourceManager.m
//  Cubeworld
//
//  Created by Tom Jones on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"

@implementation ResourceManager
-(id)init
{
    if(self = [super init]){
        programs = [[NSMutableDictionary alloc]init];
        path = @"Users/jones/cubeworld/World/";
        
    }
    return self;
}

+(ResourceManager *)sharedResourceManager
{
    static ResourceManager *shared;
    @synchronized(self)
    {
        if (!shared)
            shared = [[ResourceManager alloc] init];
        return shared;
    }
}

-(void)storeChunk:(ChunkLowMem *)chunk
{
    vec3 *chunkLocation = [chunk chunkLocation];
    NSString *chunkName = [NSString stringWithFormat:@"x%fz%f",chunkLocation->x,chunkLocation->z];

    NSData *data = [[chunk description] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    if([data writeToFile:[NSString stringWithFormat:@"/%@%@",path,chunkName] options:NSDataWritingAtomic error:&error])
        NSLog(@"Wrote chunk %@ to disk",chunkName);
    else 
        NSLog(@"Error %@",[error description]);
    
}

-(ChunkLowMem *)getChunkForXZ:(NSString *)chunk
{
    NSError *error;
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"file://%@/%@",path,chunk]];
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"/%@/%@",path,chunk] 
                                                 options:NSDataReadingUncached 
                                                   error:&error];
    if(error != nil)
        ;
    
    if(parser == nil)
        parser = [[NSXMLParser alloc]initWithData:data];
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    [parser release];
    parser = nil;
    
    if(result == nil)
        NSLog(@"Failed to load chunk");
    return result;
}

-(BOOL)chunkExistsForString:(NSString *)chunk
{
    NSString *chunkName =[NSString stringWithFormat:@"/%@/%@",path,chunk];
    return [[NSFileManager defaultManager] fileExistsAtPath:chunkName];
}

#pragma mark Handle XML data loading
-(void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName 
   attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"chunk"]) {
        result = [[[ChunkLowMem alloc]init] autorelease];
        return;
    }
    
    if([elementName isEqualToString:@"voxel"] && result != nil) {
       // NSLog(@"Started Voxel");
        int type;
        float x,y,z;
        type = [[attributeDict valueForKey:@"type"] intValue];
        x = [[attributeDict valueForKey:@"x"] floatValue];
        y = [[attributeDict valueForKey:@"y"] floatValue]; 
        z = [[attributeDict valueForKey:@"z"] floatValue];
        
        [result updateBlockType:type forX:x Y:y Z:z];
    }
}

-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"chunk"]) {
        [result setReadyToRender:YES];
        NSLog(@"Finished chunk");
        return;
    }
//    
//    if([elementName isEqualToString:@"voxel"])
//      //  NSLog(@"Finised Voxel");
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error %@",[parseError description]);
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"Started document");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"Ended document");
}

-(GLuint)getProgramLocation:(NSString *)name
{
    NSNumber *res = nil;
    if((res = [programs valueForKey:name]) != nil)
        return [res intValue];
    else {
        GLuint program = [self loadShaders:name];
        if(program == 0)
            return 0;
        [programs setValue:[NSNumber numberWithInt:program] forKey:name];
        return program;
    }
}

#pragma mark -  OpenGL shader compilation
-(GLuint)loadShaders:(NSString *)name
{
    GLuint vertShader, fragShader,_program;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    NSBundle *bundle = [NSBundle mainBundle];
    vertShaderPathname = [bundle  pathForResource:name ofType:@"vsh"];
    
    
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, 0, "position");
    glBindAttribLocation(_program, 1, "inColor");
    glBindAttribLocation(_program, 2, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    return _program;
}


- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}


- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}


- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
@end
