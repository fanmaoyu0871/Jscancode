//
//  SJLoginVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/20.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJLoginVC.h"
#import "SJLoginTextFieldCell.h"
#import "SJRegisterVC.h"
#import "YDJUserInfoModel.h"


#define textFieldCellID @"textFieldCellID"

@interface SJLoginVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_leftTitleArr;
    NSArray *_placeholderArr;
    
    NSString *_recvPhone;
    NSString *_recvPwd;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJLoginVC

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"登录";
    
    UIButton *regBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 20, 60, 44)];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:14.0f];
    [regBtn addTarget:self action:@selector(regBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:regBtn];
    
    _leftTitleArr = @[@"账号", @"密码"];
    _placeholderArr = @[@"请输入手机号", @"请输入密码"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJLoginTextFieldCell" bundle:nil] forCellReuseIdentifier:textFieldCellID];
    
    [self addTapGesture];
    
    [self createFooterView];
}

-(void)createFooterView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70, 20, 60, 30)];
    [btn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [btn setTitleColor:RGBHEX(0x47C0DD) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:12.0f];
    [btn addTarget:self action:@selector(forgetPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 80, ScreenWidth - 30*2, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"anniubeijing"] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:17.0f];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    
    self.tableView.tableFooterView = bgView;
}

#pragma mark - 登录按钮事件
-(void)loginBtnAction
{
    [self.view endEditing:YES];
    
    if(_recvPhone.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入手机号" onView:self.view];
        return;
    }
    
    if(_recvPhone.length != 11)
    {
        [YDJProgressHUD showTextToast:@"手机号码：11个数字" onView:self.view];
        return;
    }
    
    if(_recvPwd.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入密码" onView:self.view];
        return;
    }
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.login", @"name", _recvPhone, @"phone", _recvPwd, @"password", nil];
    [YDJProgressHUD showAnimationTextToast:@"登录中..." onView:self.view];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = obj;
            YDJUserInfoModel *model = [[YDJUserInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            //更新数据库
            [[YDJCoreDataManager defaultCoreDataManager]deleteTable:Table_UserInfo];
            [[YDJCoreDataManager defaultCoreDataManager]insertTable:Table_UserInfo model:model];
        }
        
        [YDJProgressHUD hideDefaultProgress:self.view];

        [Utils delayWithDuration:2.0f DoSomeThingBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [YDJProgressHUD showTextToast:@"登录成功" onView:self.view];
    } failure:^{
        [YDJProgressHUD hideDefaultProgress:self.view];
    } needToken:NO];
}

#pragma mark - 忘记密码按钮事件
-(void)forgetPwdBtnAction
{
    SJRegisterVC *vc = [[SJRegisterVC alloc]initWithNibName:@"SJRegisterVC" bundle:nil];
    vc.isForgetPwd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 注册按钮事件
-(void)regBtnAction
{
    SJRegisterVC *vc = [[SJRegisterVC alloc]initWithNibName:@"SJRegisterVC" bundle:nil];
    vc.isForgetPwd = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJLoginTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellID];
    cell.vc = self;
    if(indexPath.row == 0)
    {
        cell.tfBlock = ^(NSString *text)
        {
            _recvPhone = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row == 1)
    {
        cell.tfBlock = ^(NSString *text)
        {
            _recvPwd = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = YES;
    }
    [cell configUI:_leftTitleArr[indexPath.row] placeholder:_placeholderArr[indexPath.row]  showRightBtn:NO];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
