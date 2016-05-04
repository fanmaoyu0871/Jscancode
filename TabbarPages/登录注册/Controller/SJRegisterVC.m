//
//  SJRegisterVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/20.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJRegisterVC.h"
#import "SJLoginTextFieldCell.h"
#import <CoreText/CoreText.h>
#import "SJWebVC.h"

#define textFieldCellID @"textFieldCellID"

@interface SJRegisterVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_leftTitleArr;
    NSArray *_placeholderArr;
    UIButton *_bingoBtn;
    
    NSString *_recvPhone;
    NSString *_recvVerifyCode;
    NSString *_recvPwd;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = self.isForgetPwd?@"找回密码":@"注册";
    
    _leftTitleArr = @[@"账号", @"输入验证码", @"设置密码"];
    _placeholderArr = @[@"请输入手机号", @"输入验证码", @"请设置密码"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJLoginTextFieldCell" bundle:nil] forCellReuseIdentifier:textFieldCellID];

    [self createFooterView];
}

-(void)createFooterView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    
    _bingoBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 36, 36)];
    [_bingoBtn setImage:[UIImage imageNamed:@"xieyi-noselected"] forState:UIControlStateNormal];
    [_bingoBtn setImage:[UIImage imageNamed:@"xieyi-selected"] forState:UIControlStateSelected];
    [_bingoBtn addTarget:self action:@selector(bingoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_bingoBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_bingoBtn.right+5, 10, 200, 36)];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意用户协议"];
    [attString addAttributes:@{NSForegroundColorAttributeName:Theme_TextMainColor} range:(NSRange){0,5}];
    [attString addAttributes:@{NSForegroundColorAttributeName:Theme_MainColor} range:(NSRange){5,[attString length]-5}];
    label.attributedText = attString;
    label.font = [UIFont fontWithName:Theme_MainFont size:14.0f];
    [bgView addSubview:label];
    
    UIButton *xieyibtn = [[UIButton alloc]initWithFrame:CGRectMake(_bingoBtn.right+5, 10, 200, 36)];
    [xieyibtn addTarget:self action:@selector(xieyiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:xieyibtn];
    
    UIButton *regBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 80, ScreenWidth - 30*2, 40)];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[UIImage imageNamed:@"anniubeijing"] forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:17.0f];
    [regBtn addTarget:self action:@selector(regBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:regBtn];
    
    self.tableView.tableFooterView = bgView;
}

#pragma mark - 注册按钮事件
-(void)regBtnAction
{
    [self.view endEditing:YES];

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
    
    if(_recvVerifyCode.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入验证码" onView:self.view];
        return;
    }
    
    if(!_bingoBtn.isSelected)
    {
        [YDJProgressHUD showTextToast:@"需要同意协议才能注册哦～" onView:self.view];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.isForgetPwd?@"scancode.sys.reset.password":@"scancode.sys.register.member", @"name", _recvPhone, self.isForgetPwd?@"phone":@"mobile", _recvVerifyCode, @"code", _recvPwd, @"password", nil];
    
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        [Utils delayWithDuration:2.0f DoSomeThingBlock:^{
            
            //注册完成后，帮用户直接登录
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
                [YDJProgressHUD showTextToast:@"登录失败" onView:self.view];
                [YDJProgressHUD hideDefaultProgress:self.view];
            } needToken:YES];

        }];
        [YDJProgressHUD showTextToast:@"注册成功" onView:self.view];
    } failure:^{
        [YDJProgressHUD showTextToast:@"注册失败" onView:self.view];
    } needToken:NO];

}

#pragma mark - 进入协议按钮
-(void)xieyiBtnAction
{
    SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
    webVC.urlStr = [NSString stringWithFormat:@"http://wjwzju.oicp.net/scancode/php/page/user_agreement"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 打勾按钮
-(void)bingoBtnAction:(UIButton*)btn
{
    btn.selected = !btn.isSelected;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJLoginTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellID];
    cell.isForget = self.isForgetPwd;
    cell.vc = self;
    if(indexPath.row == 0)
    {
        SJWEAKSELF
        cell.getVerifyCodeBlock = ^{
            [weakSelf.view endEditing:YES];
        };
        cell.tfBlock = ^(NSString *text)
        {
            _recvPhone = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if(indexPath.row == 1)
    {
        cell.tfBlock = ^(NSString *text)
        {
            _recvVerifyCode = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    }
    else if (indexPath.row == 2)
    {
        cell.tfBlock = ^(NSString *text)
        {
            _recvPwd = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = YES;
    }
    [cell configUI:_leftTitleArr[indexPath.row] placeholder:_placeholderArr[indexPath.row]showRightBtn:indexPath.row==0?YES:NO];
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

@end
