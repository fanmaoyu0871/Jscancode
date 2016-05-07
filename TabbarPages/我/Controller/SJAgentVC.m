//
//  SJAgentVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/7.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJAgentVC.h"
#import "SJAgenceCell.h"

#define agentCellID @"agentCellID"

@interface SJAgentVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJAgentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = self.isSameLevel?@"我的同级":@"我的下级";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJAgenceCell" bundle:nil] forCellReuseIdentifier:agentCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    SJAgenceCell *cell = [tableView dequeueReusableCellWithIdentifier:agentCellID];
    [cell configUI];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
