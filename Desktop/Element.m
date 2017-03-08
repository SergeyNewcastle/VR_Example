//
//  Element.m
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "Element.h"




@implementation Element



#define NUM_CUBE_VERTICES 180
#define NUM_CUBE_COLORS 144


@synthesize position;
@synthesize rotation;
@synthesize inFocus;
@synthesize imageName;

static const float zVal = 0.1f;



static const char *kVertexShaderString =
"#version 300 es\n"
"\n"
"uniform mat4 model; \n"
"uniform mat4 view; \n"
"uniform mat4 projection; \n"

"layout (location = 0) in vec3 aVertex; \n"
"layout (location = 1) in vec2 texCoord; \n"

"out vec3 vGrid;  \n"
"out vec2 TexCoords; \n"

"uniform bool inFocus;\n"

"void main(void) { \n"
"    vec4 pos = vec4(aVertex, 1.0); \n"
"    if(inFocus) {"
"         pos.z += 0.2;"
"    }"
"    gl_Position = projection * view * model * pos; \n"
"    TexCoords = vec2(texCoord.x, 1.0 - texCoord.y); \n"
"}\n";


static const char *kPassThroughFragmentShaderString =
"#version 300 es\n"
"precision mediump float;\n"

"in vec2 TexCoords; \n"

"uniform bool inFocus;\n"
"uniform sampler2D imageTexture; \n"
"out vec4 fragmentColor;\n"

"void main(void) { \n"
"    fragmentColor = texture(imageTexture, TexCoords); \n"
"    if(!inFocus) { \n"
"         float midGreyColor = (fragmentColor.r + fragmentColor.g + fragmentColor.b) / 1.5;"
"         fragmentColor = vec4(midGreyColor, midGreyColor, midGreyColor, 0.85); \n"
"    }\n"
"}\n";


static const float kCubeVertices[108] = {
     // Positions
     -0.5f, -0.5f, -zVal,  
     0.5f, -0.5f, -zVal,   
     0.5f,  0.5f, -zVal,   
     0.5f,  0.5f, -zVal,   
     -0.5f,  0.5f, -zVal,  
     -0.5f, -0.5f, -zVal,  
     
     -0.5f, -0.5f,  zVal,  
     0.5f, -0.5f,  zVal,   
     0.5f,  0.5f,  zVal,   
     0.5f,  0.5f,  zVal,   
     -0.5f,  0.5f,  zVal,  
     -0.5f, -0.5f,  zVal,  
     
     -0.5f,  0.5f,  zVal,  
     -0.5f,  0.5f, -zVal,  
     -0.5f, -0.5f, -zVal,  
     -0.5f, -0.5f, -zVal,  
     -0.5f, -0.5f,  zVal,  
     -0.5f,  0.5f,  zVal,  
     
     0.5f,  0.5f,  zVal,   
     0.5f,  0.5f, -zVal,   
     0.5f, -0.5f, -zVal,   
     0.5f, -0.5f, -zVal,   
     0.5f, -0.5f,  zVal,   
     0.5f,  0.5f,  zVal,   
     
     -0.5f, -0.5f, -zVal,  
     0.5f, -0.5f, -zVal,   
     0.5f, -0.5f,  zVal,   
     0.5f, -0.5f,  zVal,   
     -0.5f, -0.5f,  zVal,  
     -0.5f, -0.5f, -zVal,  
     
     -0.5f,  0.5f, -zVal,  
     0.5f,  0.5f, -zVal,   
     0.5f,  0.5f,  zVal,   
     0.5f,  0.5f,  zVal,
     -0.5f,  0.5f,  zVal,   
     -0.5f,  0.5f, -zVal
};






static const float kCubeTextureCoord[72] = {
     // Texture Coords
     0.0f,  0.0f,
    1.0f,  0.0f,
    1.0f,  1.0f,
    1.0f,  1.0f,
     0.0f,  1.0f,
     0.0f,  0.0f,
    
     0.0f,  0.0f,
    1.0f,  0.0f,
    1.0f,  1.0f,
    1.0f,  1.0f,
     0.0f,  1.0f,
     0.0f,  0.0f,
    
     1.0f,  0.0f,
     1.0f,  1.0f,
     0.0f,  1.0f,
     0.0f,  1.0f,
     0.0f,  0.0f,
     1.0f,  0.0f,
    
    1.0f,  0.0f,
    1.0f,  1.0f,
    0.0f,  1.0f,
    0.0f,  1.0f,
    0.0f,  0.0f,
    1.0f,  0.0f,
    
     0.0f,  1.0f,
    1.0f,  1.0f,
    1.0f,  0.0f,
    1.0f,  0.0f,
     0.0f,  0.0f,
     0.0f,  1.0f,
    
     0.0f,  1.0f,
    1.0f,  1.0f,
    1.0f,  0.0f,
    1.0f,  0.0f,
     0.0f,  0.0f,
     0.0f,  1.0f
};


GLint _cube_vertex_attrib;
GLint _cube_texture_coord_attrib;
GLuint _cube_texture_coord_buffer;
GLuint _cube_vertex_buffer;

GLuint in_focus_attributeLocation;




- (instancetype)init
{
     self = [super init];
     if (self) {
//          [self create];
          [super setDelegate:self];
     }
     return self;
}

-(void) createShader {//:(const char *)v_src fragmant_shader_source:(const char*)f_src {
//     NSLog(@"Element Create Shader");
     super.shaderProgramId = [Shader create:kVertexShaderString fragmant_shader_source:kPassThroughFragmentShaderString];
}



-(void) create {
     
     
     _cube_vertex_attrib = glGetAttribLocation(super.shaderProgramId, "aVertex");
     NSAssert(_cube_vertex_attrib != -1, @"glGetAttribLocation failed for aVertex");
     
     _cube_texture_coord_attrib = glGetAttribLocation(super.shaderProgramId, "texCoord");
     NSAssert(_cube_texture_coord_attrib != -1, @"glGetAttribLocation failed for aVertex");
          
     in_focus_attributeLocation = glGetUniformLocation(super.shaderProgramId, "inFocus");
     
     glGenBuffers(1, &_cube_vertex_buffer);
     NSAssert(_cube_vertex_buffer != 0, @"glGenBuffers failed for vertex buffer");
     glBindBuffer(GL_ARRAY_BUFFER, _cube_vertex_buffer);
     glBufferData(GL_ARRAY_BUFFER, sizeof(kCubeVertices), kCubeVertices, GL_STATIC_DRAW);
     
     
     glVertexAttribPointer(_cube_vertex_attrib, 3, GL_FLOAT, GL_FALSE,  sizeof(float) * 3, 0);
     glEnableVertexAttribArray(_cube_vertex_attrib);

     
     
     glGenBuffers(1, &_cube_texture_coord_buffer);
     NSAssert(_cube_texture_coord_buffer != 0, @"glGenBuffers failed for texture buffer");
     glBindBuffer(GL_ARRAY_BUFFER, _cube_texture_coord_buffer);
     glBufferData(GL_ARRAY_BUFFER, sizeof(kCubeTextureCoord), kCubeTextureCoord, GL_STATIC_DRAW);
     
     glVertexAttribPointer(_cube_texture_coord_attrib, 2, GL_FLOAT, GL_FALSE,  sizeof(float) * 2, 0);
     glEnableVertexAttribArray(_cube_texture_coord_attrib);
     
     glBindVertexArray(0);
     
     
     

}

-(void) loadImage {
     
     UIImage * image = [UIImage imageNamed: imageName];
     
     glGenTextures(1, &_texture);
     glActiveTexture(GL_TEXTURE0 + _texture);
     
     glBindTexture(GL_TEXTURE_2D, _texture);
     glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
     glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
     
     GLuint width = CGImageGetWidth(image.CGImage);
     GLuint height = CGImageGetHeight(image.CGImage);
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     // Allocate memory for image
     void *imageData = malloc( height * width * 4 );
     CGContextRef imgcontext = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
     CGColorSpaceRelease( colorSpace );
     CGContextClearRect( imgcontext, CGRectMake( 0, 0, width, height ) );
     CGContextTranslateCTM( imgcontext, 0, height - height );
     CGContextDrawImage( imgcontext, CGRectMake( 0, 0, width, height ), image.CGImage );
     

     glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
     
     
}



-(void) prepare {
     
     super.model = GLKMatrix4Translate(super.view, position.x, position.y, position.z);
     super.model = GLKMatrix4Rotate(super.model, rotation, 0, 1, 0);
     
     glActiveTexture(GL_TEXTURE0 + _texture);
     glBindTexture(GL_TEXTURE_2D, _texture);
     
     
     glUniformMatrix4fv(glGetUniformLocation(super.shaderProgramId, "model"), 1, false, super.model.m);
     glUniformMatrix4fv(glGetUniformLocation(super.shaderProgramId, "view"), 1, false, super.view.m);
     glUniformMatrix4fv(glGetUniformLocation(super.shaderProgramId, "projection"), 1, false, super.projection.m);
     
     glUniform1i(glGetUniformLocation(super.shaderProgramId, "imageTexture"),  _texture);
     glUniform1i(in_focus_attributeLocation, (int)inFocus);
     
     
}



-(void) draw {
     glDrawArrays(GL_TRIANGLES, 0, 36);
}





@end
