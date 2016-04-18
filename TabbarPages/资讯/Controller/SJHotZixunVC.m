//
//  SJHotZixunVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJHotZixunVC.h"

#import "SJDongtaiCell.h"
#import "SJVideoCell.h"

#define dongtaiCellID @"dongtaiCellID"
#define videoCellID @"videoCellID"

@interface SJHotZixunVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SJHotZixunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDongtaiCell" bundle:nil] forCellReuseIdentifier:dongtaiCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJVideoCell" bundle:nil] forCellReuseIdentifier:videoCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section %2)
    {
        SJDongtaiCell *dongtaiCell = [tableView dequeueReusableCellWithIdentifier:dongtaiCellID];
        dongtaiCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return dongtaiCell;
    }
    else
    {
        SJVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:videoCellID];
        videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return videoCell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section %2)
    {
        return 350;
    }
    return 320.0f;
}

@end
