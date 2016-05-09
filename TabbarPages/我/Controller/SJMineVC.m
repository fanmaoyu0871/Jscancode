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
#import "SJContactUsViewController.h"
#import "SJWebVC.h"
#import "SJMyAgenceVC.h"

#define mineCellID @"mineCellID"

@interface SJMineVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
    NSArray *_rightTitleArr;
    NSArray *_imageArr;
    
    UIButton *_imageBtn;
    UILabel *_nameLabel;
    
    UIButton *_scanBtn;
    
    //已登录显示view
    UIView *_loginedView;
    
    //未登录显示view
    UIView *_noLoginView;
    
    //退出登录按钮
    UIButton *_logoutBtn;
    
    float _cacheSize;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIView *shenhezhongView;
@property (nonatomic, strong)UIView *yirenzhengView;
@property (nonatomic, strong)UIView *weirenzhongView;

@end

@implementation SJMineVC

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

-(void)calculateCache
{
    //图片缓存大小
    float size = (float)([[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0);
    float realSize = (float)(floor(size * 10) / 10);
    
    //视频本地缓存大小
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    NSFileManager* manager = [NSFileManager defaultManager];
//    
//    if ([manager fileExistsAtPath:cachePath])
//    {
//        
//        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachePath] objectEnumerator];
//        
//        NSString* fileName;
//        
//        long long folderSize = 0;
//        
//        while ((fileName = [childFilesEnumerator nextObject]) != nil){
//            
//            NSString* fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
//            
//            folderSize += [self fileSizeAtPath:fileAbsolutePath];
//            folderSize = folderSize/(1024.0*1024.0);
//        }
//        
//        realSize += (float)(floor(folderSize * 10) / 10);
    
//    }
    _cacheSize = realSize;
    
    [self.tableView reloadData];
}

-(void)configHeaderViewUI
{
    if([Utils checkLogin])
    {
        self.tableView.tableHeaderView = _loginedView;
        [_imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[YDJUserInfo sharedUserInfo].head] forState:UIControlStateNormal];
        _nameLabel.text = [YDJUserInfo sharedUserInfo].name;
        [_nameLabel sizeToFit];
        
        _logoutBtn.hidden = NO;
        _scanBtn.hidden = [[YDJUserInfo sharedUserInfo].user_type integerValue] == 2?NO:YES;
        
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

-(void)reqUserInfo
{
    [YDJProgressHUD showSystemIndicator:NO];

    if(![YDJUserInfo sharedUserInfo].user_id)
        return;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.get.user.info", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", nil];
    
    [YDJProgressHUD showSystemIndicator:YES];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        id data = dic[@"data"];
        
        if([data isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *tmpDict = data;
            NSDictionary *userInfo = tmpDict[@"info"];
            
            //这里后台没返回，自己先保存一份token
            NSString *tmpToken = [YDJUserInfo sharedUserInfo].token;
            
            YDJUserInfoModel *model = [[YDJUserInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:userInfo];
            [[YDJUserInfo sharedUserInfo]updateInfo:model];
            [YDJUserInfo sharedUserInfo].token = tmpToken;
            
            [self configHeaderViewUI];
        }
        
        [YDJProgressHUD showSystemIndicator:NO];
        
    } failure:^{
        [YDJProgressHUD showSystemIndicator:NO];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self calculateCache];
    
    //每次到这个页面我都重新请求一个个人信息
    [self reqUserInfo];
    
    [self configHeaderViewUI];
    
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
    }
    
    [_yirenzhengView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *tmpTitle = @[@"总代", @"省代", @"市代", @"美丽顾问"];
    NSInteger index = [[YDJUserInfo sharedUserInfo].level integerValue];
    NSArray *imageArr = @[@"4huangguan", @"3huangguan", @"2huangguan", @"1huangguan"];
    if(index >= 0 && index < tmpTitle.count)
    {
        UILabel *label = [UILabel labelWithFontName:Theme_MainFont fontSize:15 fontColor:[UIColor whiteColor] text:tmpTitle[index]];
        label.textAlignment = NSTextAlignmentCenter;
        [_yirenzhengView addSubview:label];
        label.center = CGPointMake(_yirenzhengView.width/2+(4-index)*10, _yirenzhengView.height/2);
        
        UIImageView *iv = [[UIImageView alloc]init];
        iv.image = [UIImage imageNamed:imageArr[index]];
        [iv sizeToFit];
        [_yirenzhengView addSubview:iv];
        iv.right = label.left;
        iv.centerY = label.centerY;
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
        [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:RGBHEX(0xa5a2a2)} range:(NSRange){6,[attString length]-6}];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        [attString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:RGBHEX(0xa5a2a2)} range:(NSRange){6,[attString length]-6}];
        
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
    
    _titleArr = @[@[@"系统消息", @"我的积分", @"我的代理", @"个人设置"], @[@"清除缓存", @"联系我们"]];
    _imageArr = @[@[@"xitongxiaoxi", @"wodejifen", @"gerenshezhi",  @"gerenshezhi"], @[@"qingchuhuancun", @"lianxiwomen"]];
    _rightTitleArr = @[@[@"", @"积分能干啥，如何赚?", @"",  @""], @[@"", @""]];
    
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
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
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
    regBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
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
    
    _scanBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 30, 50, 50)];
    [_scanBtn setImage:[UIImage imageNamed:@"saomiao"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginedView addSubview:_scanBtn];
    
    
    //只有经销商可以扫码
    _scanBtn.hidden = [[YDJUserInfo sharedUserInfo].user_type integerValue] == 2?NO:YES;
    
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
    _logoutBtn.size = CGSizeMake(240, 40);
    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutBtn setBackgroundImage:[UIImage imageNamed:@"anniubeijing"] forState:UIControlStateNormal];
    _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_logoutBtn addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_logoutBtn];
    _logoutBtn.layer.cornerRadius = 5;
    _logoutBtn.layer.masksToBounds = YES;
    _logoutBtn.center = CGPointMake(bgView.width/2, bgView.height/2);
    
    self.tableView.tableFooterView = bgView;
}

-(void)logoutBtnAction
{
    //退出登录，以游客身份登陆
    [self visitorLoginReq];
}

- (void)visitorLoginReq
{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSDictionary *dic = @{@"name": @"scancode.sys.add.tourist", @"serial_no":identifierForVendor};
    
    [YDJProgressHUD showDefaultProgress:self.view];
    [QQNetworking requestDataWithQQFormatParam:dic view:nil success:^(NSDictionary *response) {
        
        //退出登录
        self.tableView.tableHeaderView = _noLoginView;
        _logoutBtn.hidden = YES;
        
        //更新数据库
        YDJUserInfoModel *model = [[YDJUserInfoModel alloc]init];
        [[YDJUserInfo sharedUserInfo]updateInfo:model];
        [[YDJCoreDataManager defaultCoreDataManager]deleteTable:Table_UserInfo];
        
        NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊%@＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊", response);
        NSDictionary *data = response[@"data"];
        [model setValuesForKeysWithDictionary:data];
        
        NSLog(@"token = %@", [YDJUserInfo sharedUserInfo].token);

        //更新数据库
        [[YDJCoreDataManager defaultCoreDataManager]deleteTable:Table_UserInfo];
        [[YDJCoreDataManager defaultCoreDataManager]insertTable:Table_UserInfo model:model];
        //[self loginSuccess];
        
        NSLog(@"token = %@", [YDJUserInfo sharedUserInfo].token);
        
        [YDJProgressHUD hideDefaultProgress:self.view];
        [YDJProgressHUD showTextToast:@"退出登录成功" onView:self.view];
    }failure:^{
        [YDJProgressHUD hideDefaultProgress:self.view];
        [YDJProgressHUD showTextToast:@"退出登录失败" onView:self.view];
    } needToken:false];
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
        return 4;
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
    if(count > 0 && (indexPath.section == 0 && indexPath.row == 0))
    {
        str = [NSString stringWithFormat:@"有%ld条新消息", count];
    }
    else if(indexPath.section == 0 && indexPath.row == 0)
    {
        str = _rightTitleArr[indexPath.section][indexPath.row];
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        
        str = [NSString stringWithFormat:@"%@MB",[NSString judgeIntegerWithString:[NSString stringWithFormat:@"%f",_cacheSize] andValidCount:1]];
    }
    else
    {
        str = _rightTitleArr[indexPath.section][indexPath.row];
    }
    [cell configUI:_imageArr[indexPath.section][indexPath.row] leftText:_titleArr[indexPath.section][indexPath.row] rightText:str showLine:flag];
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
            
            if([[YDJUserInfo sharedUserInfo].news integerValue] <= 0)
            {
                [YDJProgressHUD showTextToast:@"暂时没有系统消息" onView:self.view];
                return;
            }
            
            SJSystemMsgVC *vc = [[SJSystemMsgVC alloc]initWithNibName:@"SJSystemMsgVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if (indexPath.row == 1) //我的积分
        {
            SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
            webVC.urlType = Wodejifen;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if (indexPath.row == 2) //我的代理
        {
            SJMyAgenceVC *agentVC = [[SJMyAgenceVC alloc]initWithNibName:@"SJMyAgenceVC" bundle:nil];
            [self.navigationController pushViewController:agentVC animated:YES];
        }
        else if(indexPath.row == 3) // 个人设置
        {
            SJPersonalSettingVC *vc = [[SJPersonalSettingVC alloc]initWithNibName:@"SJPersonalSettingVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0) //清除缓存
        {
            _cacheSize = .0f;
            [self.tableView reloadData];
            
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
            //            SJContactUsViewController *vc = [[SJContactUsViewController alloc]initWithNibName:@"SJContactUsViewController" bundle:nil];
            //            [self.navigationController pushViewController:vc animated:YES];
            
            SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
            webVC.urlType = Lianxiwomen;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

@end
