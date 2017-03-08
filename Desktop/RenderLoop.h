//
//  RenderLoop.h
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenderLoop : NSObject

- (instancetype)initWithRenderTarget:(id)target
                            selector:(SEL)selector;

- (void)invalidate;

@property(nonatomic) BOOL paused;

@end

