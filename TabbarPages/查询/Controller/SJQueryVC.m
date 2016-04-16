//
//  SJQueryVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJQueryVC.h"
#import "SJQueryCell.h"
#import "SJQueryDailiVC.h"
#import "SJQueryWuliuVC.h"

#define queryCellID @"queryCellID"

@interface SJQueryVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
    NSArray *_bgImageArr;
    NSArray *_rightImageArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end

@implementation SJQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"查询";
    
    _titleArr = @[@"鉴真伪", @"查物流", @"查代理"];
    _bgImageArr = @[@"chazhenwei", @"chawuliu", @"chadaili"];
    _rightImageArr = @[@"tiaoma", @"wuliu", @"daili"];
    
    [self.tableVIew registerNib:[UINib nibWithNibName:@"SJQueryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:queryCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:queryCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configUI:_bgImageArr[indexPath.section] title:_titleArr[indexPath.section] rightImage:_rightImageArr[indexPath.section]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenHeight - 64 - 49) / 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        SJQueryWuliuVC *vc = [[SJQueryWuliuVC alloc]initWithNibName:@"SJQueryWuliuVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (indexPath.section == 2)
    {
        SJQueryDailiVC *vc = [[SJQueryDailiVC alloc]initWithNibName:@"SJQueryDailiVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
