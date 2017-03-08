//
//  PaintedElement.h
//  TestInher
//
//  Created by Newcastle on 03.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintedProtocol.h"

@interface PaintedElement : NSObject


@property GLuint vao;
@property GLuint shaderProgramId;


@property GLKMatrix4 model;
@property GLKMatrix4 view;
@property GLKMatrix4 projection;


@property GLKVector3 position;
@property float rotation;



-(void) initialize;
-(void) paint;

@property id <PaintedProtocol> delegate;



@end
