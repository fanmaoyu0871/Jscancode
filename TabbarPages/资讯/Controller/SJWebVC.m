//
//  SJWebVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJWebVC.h"

@interface SJWebVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SJWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"详情";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    self.webView.delegate = self;
    
    [self.webView loadRequest:request];
    
    //    self.webView.scalesPageToFit = YES;
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [YDJProgressHUD showAnimationTextToast:@"加载中..." onView:self.view];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [YDJProgressHUD showTextToast:@"加载失败" onView:self.webView];
    [YDJProgressHUD hideDefaultProgress:self.view];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [YDJProgressHUD hideDefaultProgress:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
