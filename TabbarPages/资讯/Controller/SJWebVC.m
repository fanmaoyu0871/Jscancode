//
//  SJWebVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJWebVC.h"

@interface SJWebVC ()<UIWebViewDelegate>
{
    NSArray *_nameArr;
    NSArray *_navTitleArr;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SJWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArr = @[@"scancode.sys.user.point", @"scancode.sys.contact", @"scancode.sys.instruction"];
    _navTitleArr = @[@"我的积分", @"联系我们", @"用户须知"];
    
    self.webView.delegate = self;
    
    if(self.urlStr)
    {
        self.navTitle = @"详情";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [self.webView loadRequest:request];
    }
    else
    {
        if(self.urlType >= _navTitleArr.count)
            return;
        self.navTitle = _navTitleArr[self.urlType];
        [self requestWebUrl];
    }
    
    //    self.webView.scalesPageToFit = YES;
    
    if(self.urlType == ZixunAd)
    {
        UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 20, 60, 44)];
        [shareBtn setImage:[UIImage imageNamed:@"webshare"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar addSubview:shareBtn];
    }
}

-(void)requestWebUrl
{
    if(self.urlType >= _nameArr.count)
        return;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_nameArr[self.urlType], @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", nil];
    
    [QQNetworking requestDataWithQQFormatParam:params view:self.webView success:^(NSDictionary *dic) {
        
        [YDJProgressHUD hideDefaultProgress:self.view];
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *tmpDict = obj;
            NSString *url = tmpDict[@"url"];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.webView loadRequest:request];
        }
        
    } failure:^{
        [YDJProgressHUD hideDefaultProgress:self.view];
    } needToken:YES];
}

-(void)shareBtnAction
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlStr;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlStr;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"资讯详情";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"资讯详情";
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;


    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"资讯详情"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:nil];

}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [YDJProgressHUD showAnimationTextToast:@"加载中..." onView:self.webView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [YDJProgressHUD showTextToast:@"加载失败" onView:self.webView];
    [YDJProgressHUD hideDefaultProgress:self.webView];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [YDJProgressHUD hideDefaultProgress:self.webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
