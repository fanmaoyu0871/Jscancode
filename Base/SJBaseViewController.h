//
//  SJBaseViewController.h
//  SanJing
//
//  Created by 范茂羽 on 16/3/14.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJBaseViewController : UIViewController

//用于子类可以隐藏
@property (nonatomic, strong)UIButton *backBtn;

//导航栏
@property (nonatomic, strong)UIImageView *navBar;

//中间标题
@property (nonatomic, copy)NSString *navTitle;

//中间标题颜色
@property (nonatomic, strong)UIColor *titleColor;

-(void)addTapGesture;


@end
