//
//  DesktopViewController.m
//  Desktop
//
//  Created by Newcastle on 01.03.17.
//  Copyright © 2017 Newcastle. All rights reserved.
//

#import "DesktopViewController.h"

#import "Renderer.h"
#import "RenderLoop.h"

@interface DesktopViewController ()<RendererDelegate>  {
     GVRCardboardView *_cardboardView;
     Renderer *renderer;
     RenderLoop *_renderLoop;
}
@end

@implementation DesktopViewController

- (void)loadView {
     renderer = [[Renderer alloc] init];
     renderer.delegate = self;
     
     _cardboardView = [[GVRCardboardView alloc] initWithFrame:CGRectZero];
     _cardboardView.delegate = renderer;
     _cardboardView.autoresizingMask =
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     
     _cardboardView.vrModeEnabled = YES;
     
     UITapGestureRecognizer *doubleTapGesture =
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapView:)];
     doubleTapGesture.numberOfTapsRequired = 2;
     [_cardboardView addGestureRecognizer:doubleTapGesture];
     
     self.view = _cardboardView;
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     _renderLoop = [[RenderLoop alloc] initWithRenderTarget:_cardboardView
                                                   selector:@selector(render)];
}

- (void)viewDidDisappear:(BOOL)animated {
     [super viewDidDisappear:animated];
     
     // Invalidate the render loop so that it removes the strong reference to cardboardView.
     [_renderLoop invalidate];
     _renderLoop = nil;
}

- (GVRCardboardView *)getCardboardView {
     return _cardboardView;
}

#pragma mark - RendererDelegate

- (void)shouldPauseRenderLoop:(BOOL)pause {
     _renderLoop.paused = pause;
}

#pragma mark - Implementation

- (void)didDoubleTapView:(id)sender {
     _cardboardView.vrModeEnabled = !_cardboardView.vrModeEnabled;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
