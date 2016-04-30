//
//  JSTransitionAnimator.m
//  JeeSea
//
//  Created by 范茂羽 on 15/11/3.
//  Copyright © 2015年 范茂羽. All rights reserved.
//

#import "JSTransitionAnimator.h"

@implementation JSTransitionAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    if(self.isPresent)
    {
        [containerView insertSubview:fromVC.view belowSubview:toVC.view];
    }
    else
    {
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        if(self.block)
        {
            self.block();
        }
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        if(self.completionBlock)
        {
            self.completionBlock();
        }
        if(!self.isPresent)
        {
            [fromVC.view removeFromSuperview];
        }
      
    }];
}


@end
