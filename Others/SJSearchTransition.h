//
//  SJSearchTransition.h
//  SanJing
//
//  Created by 范茂羽 on 16/4/7.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJSearchTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign)CGFloat duration;

@property (nonatomic, assign)UINavigationControllerOperation operation;

@end
