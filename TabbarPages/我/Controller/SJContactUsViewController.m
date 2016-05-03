//
//  SJContactUsViewController.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/2.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJContactUsViewController.h"
#import "SJDefaultCell.h"
#import "SJWebVC.h"

#define defaultCellID @"defaultCellID"

@interface SJContactUsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _titleArray = @[@"联系客服", @"意见反馈"];
    
    self.navTitle = @"联系我们";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDefaultCell" bundle:nil] forCellReuseIdentifier:defaultCellID];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    cell.leftLabel.text = _titleArray[indexPath.section];
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
    
    NSArray *urlArray = @[];
    
    SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
    webVC.urlStr = urlArray[indexPath.section];
    [self.navigationController pushViewController:webVC animated:YES];
    
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
