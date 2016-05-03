//
//  SJQueryDailiVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJQueryDailiVC.h"
#import "SJDailiResultVC.h"
#import "SJWebVC.h"

@interface SJQueryDailiVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation SJQueryDailiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navTitle = @"代理查询";
    
    [self addTapGesture];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    [Utils delayWithDuration:0.6f DoSomeThingBlock:^{
        [self.textField becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryDailiBtnAction:(id)sender
{
    [self.view endEditing:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.agency.search", @"name", self.textField.text, @"agency_id", nil];
    
    [YDJProgressHUD showAnimationTextToast:@"查询中..." onView:self.view];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *tmpDict = obj;
            NSString *url = tmpDict[@"url"];
            SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
            webVC.urlStr = url;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
        [YDJProgressHUD hideDefaultProgress:self.view];
    } failure:^{
        [YDJProgressHUD hideDefaultProgress:self.view];
    }];
    
   
}


@end
