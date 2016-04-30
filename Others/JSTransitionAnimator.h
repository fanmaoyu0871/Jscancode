//
//  JSTransitionAnimator.h
//  JeeSea
//
//  Created by 范茂羽 on 15/11/3.
//  Copyright © 2015年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TransitionAniamtorBlock)();

typedef void(^TransitionCompletionBlock)();

@interface JSTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, copy)TransitionAniamtorBlock block;

@property (nonatomic, copy)TransitionCompletionBlock completionBlock;


@property (nonatomic, assign)BOOL isPresent;



@end
