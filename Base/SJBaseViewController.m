//
//  SJBaseViewController.m
//  SanJing
//
//  Created by 范茂羽 on 16/3/14.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseViewController.h"

@interface SJBaseViewController ()<UIGestureRecognizerDelegate>
{
    UILabel *_navLabel;
}

@end

@implementation SJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self createNavBar];
    
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _navLabel.textColor = titleColor;
}

-(void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    _navLabel.text = navTitle;
    [_navLabel sizeToFit];
    _navLabel.center = CGPointMake(ScreenWidth/2, 44);
}

-(void)createNavBar
{
    self.navBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    self.navBar.userInteractionEnabled = YES;
    self.navBar.image = [UIImage imageNamed:@"navBar"];
    [self.view addSubview:self.navBar];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, ScreenWidth, 0.5f)];
    line.backgroundColor = RGBHEX(0xf0f0f0);
    [self.navBar addSubview:line];
    
    _navLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:18.0f fontColor:[UIColor whiteColor] text:@""];
    [self.navBar addSubview:_navLabel];
    
    if(self.navigationController && self.navigationController.viewControllers.count > 1)
    {
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 80, 44)];
        [self.backBtn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
        self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
        [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar addSubview:self.backBtn];
    }
}

-(void)backAction
{
    if(self.navigationController && self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

-(void)tapAction
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"%@ has dealloced!", NSStringFromClass([self class]));
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
