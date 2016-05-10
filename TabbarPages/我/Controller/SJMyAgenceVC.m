//
//  SJMyAgenceVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/7.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJMyAgenceVC.h"
#import "SJDefaultCell.h"
#import "SJAgentVC.h"

#define cellID @"cellID"


@interface SJMyAgenceVC ()
{
    NSArray *_titleArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJMyAgenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _titleArr = @[@"我的同级", @"我的下级"];
    
    self.navTitle = @"我的代理";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDefaultCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.leftLabel.text = _titleArr[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 10.0f;
    }
    return .01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SJAgentVC *agentVC = [[SJAgentVC alloc]initWithNibName:@"SJAgentVC" bundle:nil];
    
    if(indexPath.section == 0)
    {
        agentVC.isSameLevel = YES;
    }
    else if (indexPath.section == 1)
    {
        agentVC.isSameLevel = NO;
    }
    
    [self.navigationController pushViewController:agentVC animated:YES];
}

@end
