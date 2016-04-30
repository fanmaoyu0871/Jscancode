//
//  SJPreviewVideoVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/1.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJPreviewVideoVC.h"
#import "JSTransitionAnimator.h"

@interface SJPreviewVideoVC ()<UIViewControllerTransitioningDelegate>
{
    AVPlayerLayer *_previewLayer;
    AVPlayer *_player;
    AVPlayerItem *_playItem;
}

@end

@implementation SJPreviewVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBar.hidden = YES;
    
    self.transitioningDelegate = self;
    
    _playItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:self.videoPath]];
    _player = [[AVPlayer alloc]initWithPlayerItem:_playItem];
    _previewLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//    CGRectMake(0, (ScreenHeight-h)/2, ScreenWidth, h)
    _previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    _previewLayer.frame = self.fromRect;
    [self.view.layer addSublayer:_previewLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

-(void)tapAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews
{
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - transitionDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    JSTransitionAnimator *animator = [[JSTransitionAnimator alloc]init];
    animator.isPresent = YES;
    animator.block = ^{
        CGFloat h = ScreenWidth*480/640;
        [UIView animateWithDuration:2.0f animations:^{
            _previewLayer.frame = CGRectMake(0, (ScreenHeight-h)/2, ScreenWidth, h);
        }];
    };
    animator.completionBlock = ^{
        [_player play];
    };
    
    return animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    JSTransitionAnimator *animator = [[JSTransitionAnimator alloc]init];
    animator.isPresent = NO;
    animator.block = ^{
        
        [_player pause];
        [UIView animateWithDuration:2.0f animations:^{
            _previewLayer.frame = self.fromRect;
        }];
    };
    
    animator.completionBlock = ^{
    };
    
    return animator;
}

@end
