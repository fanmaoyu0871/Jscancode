//
//  SJWuliuResultVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJWuliuResultVC.h"
#import "SJWuliuCell.h"

#define wuliuCellID @"wuliuCellID"

@interface SJWuliuResultVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJWuliuResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"物流信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJWuliuCell" bundle:nil] forCellReuseIdentifier:wuliuCellID];
    
    [self createHeaderView];
}

-(void)createHeaderView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    UILabel *topLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:12.0f fontColor:[UIColor blackColor] text:@"快递公司："];
    [bgView addSubview:topLabel];
    topLabel.left = 20;
    topLabel.top = 20;
    
    UILabel *downLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:12.0f fontColor:[UIColor blackColor] text:@"运单号"];
    [bgView addSubview:downLabel];
    downLabel.left = 20;
    downLabel.top = topLabel.bottom + 10;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height-1, ScreenWidth, 1)];
    line.backgroundColor = RGBHEX(0x979797);
    [bgView addSubview:line];
    
    self.tableView.tableHeaderView = bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJWuliuCell *cell = [tableView dequeueReusableCellWithIdentifier:wuliuCellID];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}


@end
