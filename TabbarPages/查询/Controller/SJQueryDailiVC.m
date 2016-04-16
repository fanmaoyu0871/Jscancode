//
//  SJQueryDailiVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJQueryDailiVC.h"
#import "SJDailiResultVC.h"

@interface SJQueryDailiVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation SJQueryDailiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navTitle = @"代理查询";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryDailiBtnAction:(id)sender
{
    SJDailiResultVC *vc = [[SJDailiResultVC alloc]initWithNibName:@"SJDailiResultVC" bundle:nil];
    vc.numberStr = self.textField.text;
    [self.navigationController pushViewController:vc animated:YES];

}


@end
