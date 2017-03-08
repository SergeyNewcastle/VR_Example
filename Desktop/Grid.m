//
//  Grid.m
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "Grid.h"




@implementation Grid




#define NUM_GRID_VERTICES 72
#define NUM_GRID_COLORS 96


//@synthesize position;
//@synthesize model_view_projection_matrix;
@synthesize inFocus;



static const float kGridVertices[NUM_GRID_VERTICES] = {
     // +X, +Z quadrant
     200.0f, 0.0f, 0.0f,
     0.0f, 0.0f, 0.0f,
     0.0f, 0.0f, 200.0f,
     200.0f, 0.0f, 0.0f,
     0.0f, 0.0f, 200.0f,
     200.0f, 0.0f, 200.0f,
     
     // -X, +Z quadrant
     0.0f, 0.0f, 0.0f,
     -200.0f, 0.0f, 0.0f,
     -200.0f, 0.0f, 200.0f,
     0.0f, 0.0f, 0.0f,
     -200.0f, 0.0f, 200.0f,
     0.0f, 0.0f, 200.0f,
     
     // +X, -Z quadrant
     200.0f, 0.0f, -200.0f,
     0.0f, 0.0f, -200.0f,
     0.0f, 0.0f, 0.0f,
     200.0f, 0.0f, -200.0f,
     0.0f, 0.0f, 0.0f,
     200.0f, 0.0f, 0.0f,
     
     // -X, -Z quadrant
     0.0f, 0.0f, -200.0f,
     -200.0f, 0.0f, -200.0f,
     -200.0f, 0.0f, 0.0f,
     0.0f, 0.0f, -200.0f,
     -200.0f, 0.0f, 0.0f,
     0.0f, 0.0f, 0.0f,
};

//static const float kGridColors[NUM_GRID_COLORS] = {
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//     0.0f, 0.3398f, 0.9023f, 1.0f,
//};
//
//
//

// Vertex shader implementation.
static const char *kVertexShaderString =
"#version 300 es\n"

"uniform mat4 model; \n"
"uniform mat4 view; \n"
"uniform mat4 projection; \n"
"uniform vec3 uPosition; \n"
"in vec3 aVertex; \n"
"in vec4 aColor;\n"
"out vec4 vColor;\n"
"out vec3 vGrid;  \n"
"void main(void) { \n"
"  vGrid = aVertex + uPosition; \n"
"  vec4 pos = vec4(vGrid, 1.0); \n"
"  vColor = aColor;"
//"  gl_Position = uMVP * pos; \n"
"    gl_Position = projection * view * model * vec4(aVertex, 1.0); \n"
"    \n"
"}\n";



static const char* kGridFragmentShaderString =
"#version 300 es\n"
"\n"
"#ifdef GL_ES\n"
"precision mediump float;\n"
"#endif\n"
"in vec4 vColor;\n"
"in vec3 vGrid;\n"
"out vec4 fragmentColor;\n"
"\n"
"void main() {\n"
"    float depth = gl_FragCoord.z / gl_FragCoord.w;\n"
"    if ((mod(abs(vGrid.x), 10.0) < 0.1) ||\n"
"        (mod(abs(vGrid.z), 10.0) < 0.1)) {\n"
"      fragmentColor = max(0.0, (90.0-depth) / 90.0) *\n"
"                     vec4(1.0, 1.0, 1.0, 1.0) + \n"
"                     min(1.0, depth / 90.0) * vColor;\n"
"    } else {\n"
"      fragmentColor = vColor;\n"
"    }\n"
"}\n";




//static const float kGridSize = 1.0f;


GLfloat _grid_vertices[NUM_GRID_VERTICES];
GLfloat _grid_colors[NUM_GRID_COLORS];
GLfloat _grid_position[3];


GLint _grid_vertex_attrib;
GLint _grid_color_attrib;
GLint _grid_position_uniform;
GLint _grid_mvp_matrix;
GLuint _grid_vertex_buffer;
GLuint _grid_color_buffer;


- (instancetype)init
{
     self = [super init];
     if (self) {
          [super setDelegate:self];
     }
     return self;
}


-(void) createShader {
     super.shaderProgramId = [Shader create:kVertexShaderString fragmant_shader_source:kGridFragmentShaderString];
}


-(void) create {
     
     _grid_vertex_attrib = glGetAttribLocation(super.shaderProgramId, "aVertex");
     NSAssert(_grid_vertex_attrib != -1, @"glGetAttribLocation failed for aVertex");
//     _grid_color_attrib = glGetAttribLocation(super.shaderProgramId, "aColor");
//     NSAssert(_grid_color_attrib != -1, @"glGetAttribLocation failed for aColor");
//     
     _grid_position[0] = 0;
     _grid_position[1] = -20.0f;
     _grid_position[2] = 0;
     
     for (int i = 0; i < NUM_GRID_VERTICES; ++i) {
          _grid_vertices[i] = (GLfloat)(kGridVertices[i] * kCubeSize);
     }
     
     
     glGenBuffers(1, &_grid_vertex_buffer);
     NSAssert(_grid_vertex_buffer != 0, @"glGenBuffers failed for vertex buffer");
     glBindBuffer(GL_ARRAY_BUFFER, _grid_vertex_buffer);
     glBufferData(GL_ARRAY_BUFFER, sizeof(_grid_vertices), _grid_vertices, GL_STATIC_DRAW);
     
     glVertexAttribPointer(_grid_vertex_attrib, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0);
     glEnableVertexAttribArray(_grid_vertex_attrib);
//     
//     
//     
//
//     for (int i = 0; i < NUM_GRID_COLORS; ++i) {
//          _grid_colors[i] = (GLfloat)(kGridColors[i] * kGridSize);
//     }
//     glGenBuffers(1, &_grid_color_buffer);
//     NSAssert(_grid_color_buffer != 0, @"glGenBuffers failed for color buffer");
//     glBindBuffer(GL_ARRAY_BUFFER, _grid_color_buffer);
//     glBufferData(GL_ARRAY_BUFFER, sizeof(_grid_colors), _grid_colors, GL_STATIC_DRAW);
//     

//     glVertexAttribPointer(_grid_color_attrib, 4, GL_FLOAT, GL_FALSE, sizeof(float) * 4, 0);
//     glEnableVertexAttribArray(_grid_color_attrib);
     
     
     
}



-(void) prepare {
     super.model = GLKMatrix4Translate(super.view, 0, -10, 0);
     glUniformMatrix4fv(glGetUniformLocation(super.shaderProgramId, "model"), 1, false, super.model.m);
     glUniformMatrix4fv( glGetUniformLocation(super.shaderProgramId, "view"), 1, false, super.view.m);
     glUniformMatrix4fv(glGetUniformLocation(super.shaderProgramId, "projection"), 1, false, super.projection.m);
     
}




-(void) draw {
     glDrawArrays(GL_TRIANGLES, 0, NUM_GRID_VERTICES / 3);
}



@end
