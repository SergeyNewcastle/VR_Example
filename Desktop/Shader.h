//
//  Shader.h
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//



#import "PaintedElement.h"

#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <QuartzCore/QuartzCore.h>

static const float kCubeSize = 1.0f;


@interface Shader : NSObject


+ (GLuint) create:(const char*)v_src fragmant_shader_source:(const char*)f_src;
+ (GLuint) loadShader:(GLenum) type :(const char*)shader_src;
+ (bool) checkProgramLinkStatus:(GLenum) shader_program;

     
@end
