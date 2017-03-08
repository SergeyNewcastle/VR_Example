//
//  Element.h
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "Shader.h"


@interface Element : PaintedElement<PaintedProtocol>



-(void) create;
-(void) createShader;
-(void) draw;

-(void) loadImage;

@property NSString* imageName;
@property BOOL inFocus;
@property int elementIndex;
@property GLuint texture;


@end
