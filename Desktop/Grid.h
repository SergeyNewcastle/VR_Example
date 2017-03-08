//
//  Grid.h
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "Shader.h"



@interface Grid : PaintedElement<PaintedProtocol>


-(void) create;
-(void) createShader;
-(void) draw;



@property BOOL inFocus;


@end
