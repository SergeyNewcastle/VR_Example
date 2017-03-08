//
//  Renderer.h
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "GVRCardboardView.h"

@protocol RendererDelegate <NSObject>
@optional
- (void)shouldPauseRenderLoop:(BOOL)pause;
@end

@interface Renderer : NSObject<GVRCardboardViewDelegate>

@property(nonatomic, weak) id<RendererDelegate> delegate;

@end

