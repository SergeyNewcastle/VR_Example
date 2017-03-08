//
//  PaintedProtocol.h
//  TestInhe
//
//  Created by Newcastle on 03.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#ifndef PaintedProtocol_h
#define PaintedProtocol_h

#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <QuartzCore/QuartzCore.h>


@protocol PaintedProtocol <NSObject>
@optional


-(void) updateAttributes;
-(void) paint;


-(void) create;
-(void) createShader;
-(void) prepare;
-(void) draw;



@end


#endif /* PaintedProtocol_h */
