//
//  SJTabBarController.m
//  SanJing
//
//  Created by 范茂羽 on 16/3/14.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJTabBarController.h"
#import "SJBaseViewController.h"
#import "SJNavigationController.h"
#import "SJZixunVC.h"
#import "SJQueryVC.h"
#import "SJMineVC.h"

@interface SJTabBarController ()
{
    NSArray *_titleArr;
    NSArray *_imageArr;
    NSArray *_selImageArr;
    NSArray *_vcNameArr;
}

@end

@implementation SJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArr    = @[@"查询", @"资讯", @"我"];
    _imageArr    = @[@"tabbar-chaxun-noselected", @"tabbar-zixun-noselected", @"tabbar-wo-noselected"];
    _selImageArr = @[@"tabbar-chaxun-selected", @"tabbar-zixun-selected", @"tabbar-wo-selected"];
    _vcNameArr   = @[@"SJQueryVC", @"SJZixunVC", @"SJMineVC"];
    
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for(NSInteger i = 0; i < 3; i++)
    {
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:_titleArr[i] image:[[UIImage imageNamed:_imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:_selImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        Class cls = NSClassFromString(_vcNameArr[i]);
        SJBaseViewController *vc = [(SJBaseViewController*)[cls alloc]initWithNibName:_vcNameArr[i] bundle:nil];
        SJNavigationController *navVC = [[SJNavigationController alloc]initWithRootViewController:vc];
        vc.tabBarItem = item;
        [vcArray addObject:navVC];
    }
    
    self.viewControllers = vcArray;
    
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarBeijing"]];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:Theme_MainColor} forState:UIControlStateSelected];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBHEX(0x9d9d9d)} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
