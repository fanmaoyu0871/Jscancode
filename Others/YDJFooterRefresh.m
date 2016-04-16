//
//  YDJFooterRefresh.m
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/14.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "YDJFooterRefresh.h"

@implementation YDJFooterRefresh

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.stateLabel.font = [UIFont fontWithName:Theme_MainFont size:13.0f];
    self.stateLabel.textColor = Theme_TextMainColor;
    // 设置文字
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"" forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多数据~" forState:MJRefreshStateNoMoreData];
    
    self.refreshingTitleHidden = YES;
}

//- (void)placeSubviews
//{
//    [super placeSubviews];
//    
//    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView*)[self valueForKeyPath:@"loadingView"];
////    loadingView.hidden = YES;
//    
//    if (loadingView.constraints.count) return;
//    
//    // 圈圈
//    CGFloat loadingCenterX = self.mj_w * 0.5;
//    if (!self.isRefreshingTitleHidden) {
//        loadingCenterX -= 100;
//    }
//    CGFloat loadingCenterY = self.mj_h * 0.5;
//    loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
//}


@end
