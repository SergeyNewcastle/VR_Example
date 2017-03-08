//
//  Shader.m
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//


#import "Shader.h"

@implementation Shader



+(GLuint) create:(const char *)v_src fragmant_shader_source:(const char*)f_src {
     
     const GLuint vertex_shader = [Shader loadShader:GL_VERTEX_SHADER :v_src];
     const GLuint fragment_shader = [Shader loadShader:GL_FRAGMENT_SHADER :f_src];
     
     GLuint programId = glCreateProgram();
     NSAssert(programId != 0, @"Failed to create program");
     glAttachShader(programId, vertex_shader);
     glAttachShader(programId, fragment_shader);
     glLinkProgram(programId);
     NSAssert([Shader checkProgramLinkStatus: programId], @"Failed to link _cube_program");
     
     return programId;
     
}




+ (GLuint) loadShader:(GLenum) type
                      :(const char*)shader_src {
     GLint compiled = 0;
     const GLuint shader = glCreateShader(type);
     
     if (shader == 0) { return 0; }
     
     glShaderSource(shader, 1, &shader_src, NULL);
     
     glCompileShader(shader);
     glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
     
     if (!compiled) {
          GLint info_len = 0;
          glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &info_len);
          
          if (info_len > 1) {
               char *info_log = ((char *)malloc(sizeof(char) * info_len));
               glGetShaderInfoLog(shader, info_len, NULL, info_log);
               NSLog(@"Error compiling shader:%s", info_log);
               free(info_log);
          }
          glDeleteShader(shader);
          return 0;
     }
     return shader;
}


// Checks the link status of the given program.
+ (bool)  checkProgramLinkStatus:(GLenum) shader_program {

     GLint linked = 0;
     glGetProgramiv(shader_program, GL_LINK_STATUS, &linked);
     
     if (!linked) {
          GLint info_len = 0;
          glGetProgramiv(shader_program, GL_INFO_LOG_LENGTH, &info_len);
          
          if (info_len > 1) {
               char *info_log = ((char *)malloc(sizeof(char) * info_len));
               glGetProgramInfoLog(shader_program, info_len, NULL, info_log);
               NSLog(@"Error linking program: %s", info_log);
               free(info_log);
          }
          glDeleteProgram(shader_program);
          return false;
     }
     return true;
}

@end
