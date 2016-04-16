//
//  YDJHeaderRefresh.m
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/14.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "YDJHeaderRefresh.h"

@implementation YDJHeaderRefresh

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    self.stateLabel.font = [UIFont fontWithName:Theme_MainFont size:12.0f];
    
    // 设置颜色
    self.stateLabel.textColor = Theme_TextMainColor;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 37;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView*)[self valueForKeyPath:@"loadingView"];
    if (loadingView.constraints.count == 0) {
        loadingView.center = arrowCenter;
    }
}

@end
