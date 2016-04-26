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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.register.member", @"name", [QQDataManager manager].userId, @"user_id", _recvPhone, @"mobile", _recvVerifyCode, @"code", _recvPwd, @"password", nil];
    
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        [Utils delayWithDuration:2.0f DoSomeThingBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [YDJProgressHUD showTextToast:@"注册成功" onView:self.view];
    } failure:^{
        [YDJProgressHUD showTextToast:@"注册失败" onView:self.view];
    } needToken:NO];

}

#pragma mark - 进入协议按钮
-(void)xieyiBtnAction
{
    
}

#pragma mark - 打勾按钮
-(void)bingoBtnAction:(UIButton*)btn
{
    btn.selected = !btn.isSelected;
}

#pragma mark - 获取验证码请求
-(NSInteger)reqGetVerifyCode
{
    if(_recvPhone.length == 0 || _recvPhone.length != 11)
    {
        [YDJProgressHUD showTextToast:@"手机号码：11个数字" onView:self.view];
        return -1;
    }
    
    [QQNetworking requestDataWithQQFormatParam:@{@"name":@"scancode.sys.register.sms.send", @"mobile":_recvPhone} view:self.view success:^(NSDictionary *dic) {
        [YDJProgressHUD showTextToast:@"验证码发送成功" onView:self.view];
    } failure:^{
        [YDJProgressHUD showTextToast:@"验证码发送失败" onView:self.view];
    }];
    
    return 0;
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
    if(indexPath.row == 0)
    {
        SJWEAKSELF
        cell.getVerifyCodeBlock = ^{
            [weakSelf.view endEditing:YES];
            return [weakSelf reqGetVerifyCode];
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
