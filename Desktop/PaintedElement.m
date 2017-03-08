//
//  PaintedElement.m
//  TestInher
//
//  Created by Newcastle on 03.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "PaintedElement.h"
#import "Shader.h"

@implementation PaintedElement


@synthesize vao;
@synthesize shaderProgramId;

@synthesize delegate;

@synthesize model;
@synthesize view;
@synthesize projection;

@synthesize position;
@synthesize rotation;








-(void) initialize {

     glGenVertexArrays(1, &vao);
     glBindVertexArray(vao);

     [delegate createShader];
     [delegate create];
}


NSDate *methodFinish;


-(void) paint {
     
     NSDate *methodStart = [NSDate date];
     
     
     
     NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//     NSLog(@"executionTime = %f", executionTime * 1000);
     // Bind VAO
     glUseProgram(shaderProgramId);
     glBindVertexArray(vao);
     
     
     [delegate prepare];
     [delegate draw];
     
     
     glActiveTexture(GL_TEXTURE0);
     glBindTexture(GL_TEXTURE_2D, 0);

     // Unbind VAO
     glBindVertexArray(0);
     glUseProgram(0);
     
     methodFinish = [NSDate date];
   
}







//
//NSMutableArray* availableSelectors;
//-(void) callAdditionalDelegateSelectors {
//          if(availableSelectors == nil) {
//               [self testDelegate];
//          }
//          for (int i = 0; i < availableSelectors.count; i++) {
//               [delegate performSelector:[availableSelectors[0] pointerValue]];
//          }
//
//}
//-(void) testDelegate{
//     availableSelectors = [[NSMutableArray alloc]init];
//     if([delegate respondsToSelector:@selector(setPosition)]) {
//          [availableSelectors insertObject: [NSValue valueWithPointer:@selector(setPosition)]
//                                   atIndex: [availableSelectors count]];
//     }
//}


@end
