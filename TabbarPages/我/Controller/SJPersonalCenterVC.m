//
//  SJPersonalCenterVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJPersonalCenterVC.h"

#import "SJDongtaiCell.h"
#import "SJVideoCell.h"

#define dongtaiCellID @"dongtaiCellID"
#define videoCellID @"videoCellID"

@interface SJPersonalCenterVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJPersonalCenterVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDongtaiCell" bundle:nil] forCellReuseIdentifier:dongtaiCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJVideoCell" bundle:nil] forCellReuseIdentifier:videoCellID];
    
    [self createHeaderView];
}

-(void)createHeaderView
{
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    headerView.image = [UIImage imageNamed:@"gerenzhongxinHeaderView"];
    headerView.userInteractionEnabled = YES;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [backBtn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    UIImageView *touxiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, backBtn.bottom+5, 65, 65)];
    touxiangImageView.layer.cornerRadius = touxiangImageView.width/2;
    touxiangImageView.layer.masksToBounds = YES;
    touxiangImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    touxiangImageView.layer.borderWidth = 1;
    [headerView addSubview:touxiangImageView];
    
    UILabel *nameLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:17.0f fontColor:[UIColor whiteColor] text:@"扫码啦"];
    nameLabel.left = touxiangImageView.right + 20;
    nameLabel.top = touxiangImageView.top + 10;
    [headerView addSubview:nameLabel];
    
    UILabel *stateLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:12.0f fontColor:[UIColor whiteColor] text:@"认证状态"];
    stateLabel.left = touxiangImageView.right + 20;
    stateLabel.top = nameLabel.bottom + 5;
    [headerView addSubview:stateLabel];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 发布动态按钮事件
- (IBAction)distributeBtnAction:(id)sender
{
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
