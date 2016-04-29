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
#import "SJScanCodeVC.h"
#import "SJLoginVC.h"
#import "SJSystemMsgVC.h"

#define mineCellID @"mineCellID"

@interface SJMineVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
    NSArray *_rightTitleArr;
    NSArray *_imageArr;
    
    UIButton *_imageBtn;
    UILabel *_nameLabel;
    
    //已登录显示view
    UIView *_loginedView;
    
    //未登录显示view
    UIView *_noLoginView;
    
    //退出登录按钮
    UIButton *_logoutBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIView *shenhezhongView;
@property (nonatomic, strong)UIView *yirenzhengView;
@property (nonatomic, strong)UIView *weirenzhongView;

@end

@implementation SJMineVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([Utils checkLogin])
    {
        self.tableView.tableHeaderView = _loginedView;
        [_imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[YDJUserInfo sharedUserInfo].head] forState:UIControlStateNormal];
        _nameLabel.text = [YDJUserInfo sharedUserInfo].name;
        [_nameLabel sizeToFit];
        
        _logoutBtn.hidden = NO;
        
        NSInteger valid = [[YDJUserInfo sharedUserInfo].validation integerValue];
        if(valid == -1)
        {
            [_loginedView addSubview:self.weirenzhongView];
        }
        else if (valid == 0)
        {
            [_loginedView addSubview:self.shenhezhongView];
        }
        else if(valid == 1)
        {
            [_loginedView addSubview:self.yirenzhengView];
            
        }
        
        [self.view setNeedsLayout];
        
    }
    else
    {
        _logoutBtn.hidden = YES;
        
        self.tableView.tableHeaderView = _noLoginView;
    }
    
}

-(void)viewDidLayoutSubviews
{
    _imageBtn.center = CGPointMake(ScreenWidth/2, 70);
    _nameLabel.center = CGPointMake(ScreenWidth/2, _imageBtn.bottom+20);
    
    NSInteger valid = [[YDJUserInfo sharedUserInfo].validation integerValue];
    if(valid == -1)
    {
        [_loginedView addSubview:self.weirenzhongView];
        self.shenhezhongView.hidden = YES;
        self.yirenzhengView.hidden = YES;
        self.weirenzhongView.hidden = NO;
        self.weirenzhongView.center = CGPointMake(ScreenWidth/2, _nameLabel.bottom + 20);

    }
    else if (valid == 0)
    {
        [_loginedView addSubview:self.shenhezhongView];
        self.shenhezhongView.hidden = NO;
        self.yirenzhengView.hidden = YES;
        self.weirenzhongView.hidden = YES;
        self.shenhezhongView.center = CGPointMake(ScreenWidth/2, _nameLabel.bottom + 20);

    }
    else if(valid == 1)
    {
        [_loginedView addSubview:self.yirenzhengView];
        self.shenhezhongView.hidden = YES;
        self.yirenzhengView.hidden = NO;
        self.weirenzhongView.hidden = YES;
        self.yirenzhengView.center = CGPointMake(ScreenWidth/2, _nameLabel.bottom + 15);

    }

}

-(UIView *)shenhezhongView
{
    if(_shenhezhongView == nil)
    {
        _shenhezhongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        UILabel *label = [UILabel labelWithFontName:Theme_MainFont fontSize:15 fontColor:[UIColor whiteColor] text:@"已申请认证经销商（审核中）"];
        label.textAlignment = NSTextAlignmentCenter;
        [_shenhezhongView addSubview:label];
        label.frame = _shenhezhongView.bounds;
    }
    
    return _shenhezhongView;
}

-(UIView *)yirenzhengView
{
    if(_yirenzhengView == nil)
    {
        _yirenzhengView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        
        NSArray *tmpTitle = @[@"总代", @"省代", @"市代", @"美丽顾问"];
        NSInteger index = [[YDJUserInfo sharedUserInfo].level integerValue];
        if(index >= 0 && index < tmpTitle.count)
        {
            UILabel *label = [UILabel labelWithFontName:Theme_MainFont fontSize:15 fontColor:[UIColor whiteColor] text:tmpTitle[index]];
            label.textAlignment = NSTextAlignmentCenter;
            [_yirenzhengView addSubview:label];
            label.center = CGPointMake(_yirenzhengView.width/2, _yirenzhengView.height/2);
        }
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

    [self createNoLoginHeaderView];
    
    [self createLoginedHeaderView];
    
    [self createFooterView];
}

-(void)createNoLoginHeaderView
{
    _noLoginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:_noLoginView.bounds];
    iv.image = [UIImage imageNamed:@"gerenzhongxin-beijing"];
    [_noLoginView addSubview:iv];
    
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
    [regBtn addTarget:self action:@selector(renzhengBtnAction) forControlEvents:UIControlEventTouchUpInside];
    regBtn.size = CGSizeMake(200, 40);
    [_noLoginView addSubview:regBtn];
    regBtn.center = CGPointMake(ScreenWidth/2, line.bottom + 30);
    
}

-(void)createLoginedHeaderView
{
    _loginedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:_noLoginView.bounds];
    iv.image = [UIImage imageNamed:@"gerenzhongxin-beijing"];
    [_loginedView addSubview:iv];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 30, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"saomiao"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginedView addSubview:btn];
    

    //只有经销商可以扫码
    btn.hidden = [[YDJUserInfo sharedUserInfo].user_type integerValue] == 2?NO:YES;
    
    _imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _imageBtn.layer.cornerRadius = 40;
    _imageBtn.layer.masksToBounds = YES;
    [_imageBtn addTarget:self action:@selector(imageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginedView addSubview:_imageBtn];
    
    _nameLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:17 fontColor:[UIColor whiteColor] text:@"- - -"];
    [_loginedView addSubview:_nameLabel];

}

#pragma mark - 头像按钮事件
-(void)imageBtnAction
{
    SJPersonalCenterVC *vc = [[SJPersonalCenterVC alloc]initWithNibName:@"SJPersonalCenterVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 扫码按钮事件
-(void)scanBtnAction
{
    SJScanCodeVC *vc = [[SJScanCodeVC alloc]initWithNibName:@"SJScanCodeVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 登录按钮事件
-(void)loginBtnAction
{
    SJLoginVC *vc = [[SJLoginVC alloc]initWithNibName:@"SJLoginVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)createFooterView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    _logoutBtn = [[UIButton alloc]init];
    _logoutBtn.size = CGSizeMake(200, 40);
    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutBtn setBackgroundImage:[UIImage imageNamed:@"anniubeijing"] forState:UIControlStateNormal];
    _logoutBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:16.0f];
    [_logoutBtn addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_logoutBtn];
    _logoutBtn.layer.cornerRadius = 5;
    _logoutBtn.layer.masksToBounds = YES;
    _logoutBtn.center = CGPointMake(bgView.width/2, bgView.height/2);
    
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
    
    NSInteger count = [[YDJUserInfo sharedUserInfo].news integerValue];
    NSString *str = @"";
    if(count > 0)
    {
        str = [NSString stringWithFormat:@"有%ld条新消息", count];
    }
    [cell configUI:_imageArr[indexPath.section][indexPath.row] leftText:_titleArr[indexPath.section][indexPath.row] rightText:(indexPath.section==0&&indexPath.row==1)?str:_rightTitleArr[indexPath.section][indexPath.row] showLine:flag];
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
        if(indexPath.row == 0)
        {
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.read.sysnews",@"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id",  nil];
            [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                
            } failure:^{
                
            }];
            
            SJSystemMsgVC *vc = [[SJSystemMsgVC alloc]initWithNibName:@"SJSystemMsgVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if (indexPath.row == 1) //我的积分
        {
            
        }
        else if(indexPath.row == 2) // 个人设置
        {
            SJPersonalSettingVC *vc = [[SJPersonalSettingVC alloc]initWithNibName:@"SJPersonalSettingVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0) //清除缓存
        {
            [[SDImageCache sharedImageCache]clearDisk];
            [[SDImageCache sharedImageCache]clearMemory];
            [YDJProgressHUD showTextToast:@"清除缓存成功" onView:self.view];
            
            //清除本地视频缓存
            NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDir error:NULL];
            NSLog(@"%@", files);
            [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *fileName = obj;
                if([[fileName pathExtension]isEqualToString:@"mp4"])
                {
                    NSString *filePath = [cacheDir stringByAppendingPathComponent:fileName];
                    [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];

                }
            }];
        }
        else if (indexPath.row == 1) //联系我们
        {
            
        }
    }
}

@end
