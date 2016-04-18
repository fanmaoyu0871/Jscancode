//
//  SJMineVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJMineVC.h"
#import "SJMineCell.h"
#import <CoreText/CoreText.h>
#import "SJRenzhengVC.h"
#import "SJPersonalSettingVC.h"
#import "SJPersonalCenterVC.h"

#define mineCellID @"mineCellID"

@interface SJMineVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
    NSArray *_rightTitleArr;
    NSArray *_imageArr;
    
    UIView *_headerView;
    
    //已登录显示view
    UIView *_loginedView;
    
    //未登录显示view
    UIView *_noLoginView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIView *shenhezhongView;
@property (nonatomic, strong)UIView *yirenzhengView;
@property (nonatomic, strong)UIView *weirenzhongView;

@end

@implementation SJMineVC

-(UIView *)shenhezhongView
{
    if(_shenhezhongView == nil)
    {
        _shenhezhongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        UILabel *label = [UILabel labelWithFontName:Theme_MainFont fontSize:15 fontColor:[UIColor whiteColor] text:@"已申请认证经销商（审核中）"];
        label.textAlignment = NSTextAlignmentCenter;
        [_shenhezhongView addSubview:label];
        label.center = CGPointMake(_shenhezhongView.width/2, _shenhezhongView.height/2);
    }
    
    return _shenhezhongView;
}

-(UIView *)yirenzhengView
{
    if(_yirenzhengView == nil)
    {
        
    }
    
    return _yirenzhengView;
}

-(UIView *)weirenzhongView
{
    if(_weirenzhongView == nil)
    {
        _weirenzhongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];

        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"未认证经销商(去认证)"];
        [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){6,[attString length]-6}];
        [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:(NSRange){6,[attString length]-6}];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        [attString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:(NSRange){6,[attString length]-6}];
        
        UILabel *label = [[UILabel alloc]initWithFrame:_weirenzhongView.bounds];
        label.textColor = [UIColor whiteColor];
        label.attributedText = attString;
        label.textAlignment = NSTextAlignmentCenter;
        [_weirenzhongView addSubview:label];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:_weirenzhongView.bounds];
        [btn addTarget:self action:@selector(renzhengBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_weirenzhongView addSubview:btn];
        
    }
    
    return _weirenzhongView;
}

#pragma mark - 认证按钮事件
-(void)renzhengBtnAction
{
    SJRenzhengVC *vc = [[SJRenzhengVC alloc]initWithNibName:@"SJRenzhengVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navTitle = @"我";
    
    self.navBar.hidden = YES;
    
    _titleArr = @[@[@"系统消息", @"我的积分", @"个人设置"], @[@"清除缓存", @"联系我们"]];
    _imageArr = @[@[@"xitongxiaoxi", @"wodejifen", @"gerenshezhi"], @[@"qingchuhuancun", @"lianxiwomen"]];
    _rightTitleArr = @[@[@"", @"积分能干啥，如何赚?", @""], @[@"", @""]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJMineCell" bundle:nil] forCellReuseIdentifier:mineCellID];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:_headerView.bounds];
    iv.image = [UIImage imageNamed:@"gerenzhongxin-beijing"];
    [_headerView addSubview:iv];
    self.tableView.tableHeaderView = _headerView;

//    [self createNoLoginHeaderView];
    
    [self createLoginedHeaderView];
    
    [self createFooterView];
}

-(void)createNoLoginHeaderView
{
    _noLoginView = [[UIView alloc]initWithFrame:_headerView.bounds];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:20.0f];
    loginBtn.size = CGSizeMake(100, 40);
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_noLoginView addSubview:loginBtn];
    loginBtn.center = CGPointMake(ScreenWidth/2, _noLoginView.height/2 - 30);
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 2)];
    line.backgroundColor = [UIColor whiteColor];
    [_noLoginView addSubview:line];
    line.center = CGPointMake(ScreenWidth/2, loginBtn.bottom + 10);
    
    UIButton *regBtn = [[UIButton alloc]init];
    [regBtn setTitle:@"直接注册经销商" forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:20.0f];
    [regBtn addTarget:self action:@selector(regBtnAction) forControlEvents:UIControlEventTouchUpInside];
    regBtn.size = CGSizeMake(200, 40);
    [_noLoginView addSubview:regBtn];
    regBtn.center = CGPointMake(ScreenWidth/2, line.bottom + 30);
    
    [_headerView addSubview:_noLoginView];
}

-(void)createLoginedHeaderView
{
    _loginedView = [[UIView alloc]initWithFrame:_headerView.bounds];
    
    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_loginedView addSubview:imageBtn];
    imageBtn.center = CGPointMake(ScreenWidth/2, 70);
    
    UILabel *nameLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:17 fontColor:[UIColor whiteColor] text:@"- - -"];
    [_loginedView addSubview:nameLabel];
    nameLabel.center = CGPointMake(ScreenWidth/2, imageBtn.bottom+20);
    
    [_loginedView addSubview:self.weirenzhongView];
    self.weirenzhongView.center = CGPointMake(ScreenWidth/2, nameLabel.bottom + 20);

    [_headerView addSubview:_loginedView];
}

#pragma mark - 登录按钮事件
-(void)loginBtnAction
{
    
}

#pragma mark - 注册经销商按钮事件
-(void)regBtnAction
{
    
}

-(void)createFooterView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.size = CGSizeMake(200, 40);
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"anniubeijing"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:16.0f];
    [btn addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.center = CGPointMake(bgView.width/2, bgView.height/2);
    
    self.tableView.tableFooterView = bgView;
}

-(void)logoutBtnAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJMineCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellID];
    
    BOOL flag = NO;
    if((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 1))
    {
        flag = YES;
    }
    
    [cell configUI:_imageArr[indexPath.section][indexPath.row] leftText:_titleArr[indexPath.section][indexPath.row] rightText:_rightTitleArr[indexPath.section][indexPath.row] showLine:flag];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 2) // 个人设置
        {
//            SJPersonalSettingVC *vc = [[SJPersonalSettingVC alloc]initWithNibName:@"SJPersonalSettingVC" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
            SJPersonalCenterVC *vc = [[SJPersonalCenterVC alloc]initWithNibName:@"SJPersonalCenterVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
