//
//  SJSearchTransition.m
//  SanJing
//
//  Created by 范茂羽 on 16/4/7.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJSearchTransition.h"

@implementation SJSearchTransition
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [toViewController.view layoutIfNeeded];
    
    [UIView transitionFromView:fromViewController.view
                        toView:toViewController.view
                      duration:self.duration
                       options:self.operation == UINavigationControllerOperationPush?UIViewAnimationOptionTransitionNone:UIViewAnimationOptionCurveLinear
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                    }];
    
}

@end
