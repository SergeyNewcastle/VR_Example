
//
//  Renderer.m
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "Renderer.h"
#import "Shader.h"
#import "Element.h"
#import "Grid.h"

#import "GVRHeadTransform.h"

static BOOL GLKMatrix4EqualToMatrix4(GLKMatrix4 a, GLKMatrix4 b)
{
     return
     a.m00 == b.m00 &&
     a.m01 == b.m01 &&
     a.m02 == b.m02 &&
     a.m03 == b.m03 &&
     a.m10 == b.m10 &&
     a.m11 == b.m11 &&
     a.m12 == b.m12 &&
     a.m13 == b.m13 &&
     a.m20 == b.m20 &&
     a.m21 == b.m21 &&
     a.m22 == b.m22 &&
     a.m23 == b.m23 &&
     a.m30 == b.m30 &&
     a.m31 == b.m31 &&
     a.m32 == b.m32 &&
     a.m33 == b.m33;
}


static const int elementsCount = 5;
static const float kFocusThresholdRadians = 0.5f;

static float xPos[] = { -1.5, -1.1, 0, 1.1, 1.5 };
static float zPos[] = { -0.2, -1.4, -1.8, -1.4, -0.2 };
static int angles[] = { -90, 45, 0, -45, 90 };
static NSString* imageNames[] = {@"image_01", @"image_02", @"image_03", @"image_04", @"image_05"};
static NSMutableArray* positions = nil;



@implementation Renderer {
     NSMutableArray* elementsCollection;
     Grid *grid;
     
     int _success_source_id;
     bool _is_cube_focused;
}

#pragma mark - GVRCardboardViewDelegate overrides

- (void)cardboardView:(GVRCardboardView *)cardboardView
     willStartDrawing:(GVRHeadTransform *)headTransform {
     
     [self initDesktop];
     [self initGrid];
     
}





-(void) initDesktop {
     elementsCollection = [[NSMutableArray alloc] init];
     
     
     for(int i = 0; i < elementsCount; i++) {
          
          Element *element = [[Element alloc] init];
          
          [element setPosition:GLKVector3Make(xPos[i], 0, zPos[i])];
          [element setRotation:GLKMathDegreesToRadians(angles[i])];
          [element setImageName:imageNames[i]];
          [element loadImage];
          
          
          
          [elementsCollection insertObject:element atIndex:[elementsCollection count]];
          [[elementsCollection objectAtIndex:i] initialize];
     }
     
}

-(void) initGrid { //Just for beauty
     grid = [[Grid alloc] init];
     [grid initialize];
}






- (void)cardboardView:(GVRCardboardView *)cardboardView
     prepareDrawFrame:(GVRHeadTransform *)headTransform {

     const GLKQuaternion head_rotation =
          GLKQuaternionMakeWithMatrix4(GLKMatrix4Transpose([headTransform headPoseInStartSpace]));

     for(const Element* element in elementsCollection) {
          GLKVector3 source_cube_position = [element position];
          [element setInFocus: [self isLookingAtObject:&head_rotation sourcePosition:&source_cube_position]];
     }
     
     // Clear GL viewport.
     glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
     glEnable(GL_DEPTH_TEST);
     glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
     glEnable(GL_SCISSOR_TEST);
     
     
}



GLKMatrix4 head_from_start_matrix;


- (void)cardboardView:(GVRCardboardView *)cardboardView
              drawEye:(GVREye)eye
    withHeadTransform:(GVRHeadTransform *)headTransform {
 
     
     
     CGRect viewport = [headTransform viewportForEye:eye];
     glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
     glScissor(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
     
     
     const GLKMatrix4 head_from_start_matrix = [headTransform headPoseInStartSpace];

     
     GLKMatrix4 projection_matrix = [headTransform projectionMatrixForEye:eye near:0.1f far:100.0f];
     GLKMatrix4 eye_from_head_matrix = [headTransform eyeFromHeadMatrix:eye];
     
     GLKMatrix4 view = GLKMatrix4Multiply(eye_from_head_matrix, head_from_start_matrix);
     
     
//     
//     
     for(const Element* element in elementsCollection) {
//          GLKMatrix4 model;
//          model = GLKMatrix4Translate(view, element.position.x, element.position.y, element.position.z);
//          model = GLKMatrix4Rotate(model, [element rotation], 0, 1, 0);
//          [element setModel:model];
          
          [element setView:view];
          [element setProjection:projection_matrix];
          [element paint];
     }

//     GLKMatrix4 model;
//     model = GLKMatrix4Translate(view, 0, -10, 0);
//     [grid setModel:model];
     
     [grid setView:view];
     [grid setProjection:projection_matrix];
     [grid paint];
     
 
     
//     [NSThread sleepForTimeInterval:0.04];
     
}




- (void)cardboardView:(GVRCardboardView *)cardboardView
         didFireEvent:(GVRUserEvent)event {
     switch (event) {
          case kGVRUserEventBackButton:
               NSLog(@"User pressed back button");
               break;
          case kGVRUserEventTilt:
               NSLog(@"User performed tilt action");
               break;
          case kGVRUserEventTrigger:
               NSLog(@"User performed trigger action");
               break;
     }
}

- (void)cardboardView:(GVRCardboardView *)cardboardView shouldPauseDrawing:(BOOL)pause {
     if ([self.delegate respondsToSelector:@selector(shouldPauseRenderLoop:)]) {
          [self.delegate shouldPauseRenderLoop:pause];
     }

}




// Returns whether the object is currently on focus.
- (bool)isLookingAtObject:(const GLKQuaternion *)head_rotation
           sourcePosition:(GLKVector3 *)position {
     
     GLKVector3 source_direction = GLKQuaternionRotateVector3(GLKQuaternionInvert(*head_rotation), *position);
     
     return ABS(source_direction.v[0]) < kFocusThresholdRadians
            && ABS(source_direction.v[1]) < kFocusThresholdRadians;
}




@end
