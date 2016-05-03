//
//  SJRenzhengVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJRenzhengVC.h"
#import "SJTextFieldCell.h"
#import "SJPickerCell.h"
#import "SJAddressCell.h"
#import "ActionSheetStringPicker.h"
#import "SJUploadPhotoVC.h"
#import "SJLoginTextFieldCell.h"
#import "SJWebVC.h"

#define loginTextFieldCellID @"loginTextFieldCellID"
#define textFieldCellID @"textFieldCellID"
#define pickerCellID @"pickerCellID"
#define addressCellID @"addressCellID"

extern NSString* uploadPhotoSuccessNotification;

@interface SJRenzhengVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
    NSArray *_placeTitleArr;
    
    UIButton *_binggoBtn;
    UIButton *_commitBtn;
    
    NSString *_shangjiName;
    NSString *_shangjiPhoneNum;
    NSString *_shangjiWeixinNum;
    NSInteger _levelId;
    NSInteger _sexId;
    NSString *_myName;
    NSString *_myId;
    NSString *_myPhoneNum;
    NSString *_myWeixinNum;
    NSArray *_myCity;
    NSString *_myCityStr;
    NSString *_myPwd;
    NSString *_myVerifyCode;
    
    NSString *_picPath;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJRenzhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadPhotoSuccess:) name:uploadPhotoSuccessNotification object:nil];
    
    self.navTitle = @"认证经销商";
    _levelId = -1;
    _sexId = -1;

    
    if([Utils checkLogin])
    {
        
        // 3, 5, 9,10 picker
        _titleArr = @[@"上级经销商姓名", @"上级经销商手机号", @"上级经销商微信号", @"经销商级别选择", @"您的真实姓名", @"性别", @"您的身份证号", @"手机号", @"微信号", @"地区", @"上传您的手持身份证照片"];
        _placeTitleArr = @[@"请输入姓名", @"请输入上级经销商手机号", @"请输入上级经销商微信号", @"选择经销商级别", @"真实姓名", @"选择性别", @"请输入身份证号", @"请输入手机号", @"请输入微信号", @"选择地区", @"上传照片"];
    }
    else
    {
        _titleArr = @[@"上级经销商姓名", @"上级经销商手机号", @"上级经销商微信号", @"经销商级别选择", @"您的真实姓名", @"性别", @"您的身份证号", @"手机号", @"输入验证码", @"设置密码", @"微信号", @"地区", @"上传您的手持身份证照片"];
        _placeTitleArr = @[@"请输入姓名", @"请输入上级经销商手机号", @"请输入上级经销商微信号", @"选择经销商级别", @"真实姓名", @"选择性别", @"请输入身份证号", @"请输入手机号", @"请输入获得的验证码", @"请输入密码", @"请输入微信号", @"选择地区", @"上传照片"];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJLoginTextFieldCell" bundle:nil] forCellReuseIdentifier:loginTextFieldCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJTextFieldCell" bundle:nil] forCellReuseIdentifier:textFieldCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJPickerCell" bundle:nil] forCellReuseIdentifier:pickerCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJAddressCell" bundle:nil] forCellReuseIdentifier:addressCellID];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//    [self.view addGestureRecognizer:tap];
    
    [self createFooterView];
}



-(void)uploadPhotoSuccess:(NSNotification*)noti
{
    _picPath = noti.object;
    
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)tapAction
{
    [self.tableView endEditing:YES];
    [UIView animateWithDuration:0.3f animations:^{
        [self.tableView setContentInset:UIEdgeInsetsZero];
    }];
}

-(void)createFooterView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    
    _binggoBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    [_binggoBtn setBackgroundImage:[UIImage imageNamed:@"xieyi-noselected"] forState:UIControlStateNormal];
    [_binggoBtn setBackgroundImage:[UIImage imageNamed:@"xieyi-selected"] forState:UIControlStateSelected];
    [_binggoBtn addTarget:self action:@selector(bingoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_binggoBtn];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_binggoBtn.right + 10, 20, 200, 20)];
    label.font = [UIFont systemFontOfSize:13.0f];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"阅读并同意用户协议"];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:Theme_MainColor} range:(NSRange){5, attrStr.length-5}];
    label.attributedText = attrStr;
    [bgView addSubview:label];
    
    UIButton *xieyiBtn = [[UIButton alloc]initWithFrame:CGRectMake(_binggoBtn.right + 10, 20, 200, 50)];
    [xieyiBtn addTarget:self action:@selector(xieyiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:xieyiBtn];
    
    _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"anniubeijing"] forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"anniuEnable"] forState:UIControlStateDisabled];
    [_commitBtn setTitle:[Utils checkLogin]?@"认证成为经销商":@"认证成为经销商并登录" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_commitBtn];
    _commitBtn.center = CGPointMake(ScreenWidth/2, xieyiBtn.bottom + 10);
    _commitBtn.enabled = _binggoBtn.isSelected;
    
    self.tableView.tableFooterView = bgView;
}

-(void)bingoBtnAction:(UIButton*)btn
{
    btn.selected = !btn.isSelected;
    _commitBtn.enabled = btn.isSelected;
}

#pragma mark - 协议按钮
-(void)xieyiBtnAction
{
    SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
    webVC.urlStr = [NSString stringWithFormat:@"http://wjwzju.oicp.net/scancode/php/page/user_agreement"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 提交按钮事件
-(void)commitBtnAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(_shangjiName.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入上级经销商姓名" onView:self.view];
        return;
    }
    
    if(_shangjiName.length > 8)
    {
        [YDJProgressHUD showTextToast:@"姓名8个字符以内哦～" onView:self.view];
        return;
    }
    
    if(_shangjiName)
    {
        [params setObject:_shangjiName forKey:@"pre_name"];
    }
    
    if(_shangjiPhoneNum.length == 0 || _shangjiPhoneNum.length != 11)
    {
        [YDJProgressHUD showTextToast:@"请输入11位手机号" onView:self.view];
        return;
    }
    
    if(_shangjiPhoneNum)
    {
        [params setObject:_shangjiPhoneNum forKey:@"pre_phone"];
    }
    
    if(_shangjiWeixinNum.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入上级经销商微信号" onView:self.view];
        return;
    }
    
    if(_shangjiWeixinNum)
    {
        [params setObject:_shangjiWeixinNum forKey:@"pre_weixin"];
    }
    
    
    if(_levelId == -1)
    {
        [YDJProgressHUD showTextToast:@"请选择经销商级别" onView:self.view];
        return;
    }
    

    [params setObject:@(_levelId) forKey:@"level"];
    
    if(_myName.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入您的真实姓名" onView:self.view];
        return;
    }
    
    if(_myName.length > 8)
    {
        [YDJProgressHUD showTextToast:@"姓名8个字符以内哦～" onView:self.view];
        return;
    }
    
    if(_myName)
    {
        [params setObject:_myName forKey:@"user_name"];
    }
    
    if(_sexId == -1)
    {
        [YDJProgressHUD showTextToast:@"请选择性别" onView:self.view];
        return;
    }
    
    [params setObject:@(_sexId) forKey:@"sex"];
    
    if(_myId.length == 0 || _myId.length != 18)
    {
        [YDJProgressHUD showTextToast:@"请输入您的18位身份证号" onView:self.view];
        return;
    }
    
    if(_myId)
    {
        [params setObject:_myId forKey:@"id_card"];
    }
    
    if(_myPhoneNum.length == 0 || _myPhoneNum.length != 11)
    {
        [YDJProgressHUD showTextToast:@"请输入您的11位手机号" onView:self.view];
        return;
    }
    
    if(_myPhoneNum)
    {
        [params setObject:_myPhoneNum forKey:@"phone"];
    }
    
    if(_myWeixinNum.length == 0)
    {
        [YDJProgressHUD showTextToast:@"请输入您微信号" onView:self.view];
        return;
    }
    
    if(_myWeixinNum)
    {
        [params setObject:_myWeixinNum forKey:@"weixin"];
    }
    
    if(_myCity.count == 0)
    {
        [YDJProgressHUD showTextToast:@"请选择地区" onView:self.view];
        return;
    }
    
    [params setObject:_myCity[0] forKey:@"province"];
    [params setObject:_myCity[1] forKey:@"city"];
    [params setObject:_myCity[2] forKey:@"area"];
    
    if(_picPath == nil)
    {
        [YDJProgressHUD showTextToast:@"请上传身份证照片" onView:self.view];
        return;
    }
    
    [params setObject:_picPath forKey:@"id_img"];
    
    if(!_binggoBtn.isSelected)
    {
        [YDJProgressHUD showTextToast:@"需要先同意用户协议哦～" onView:self.view];
        return;
    }
    
    //这里判断是游客登录还是非游客
    if([Utils checkLogin]) //非游客
    {
        [params setObject:@"scancode.sys.agency.valid" forKey:@"name"];
    }
    else
    {
        [params setObject:@"scancode.sys.register.agency" forKey:@"name"];

        if(_myPwd.length == 0)
        {
            [YDJProgressHUD showTextToast:@"请设置密码" onView:self.view];
            return;
        }
        
        [params setObject:_myPwd forKey:@"password"];

        
        if(_myVerifyCode.length == 0)
        {
            [YDJProgressHUD showTextToast:@"请输入验证码" onView:self.view];
            return;
        }
        [params setObject:_myVerifyCode forKey:@"code"];
    }
    
    [params setObject:[YDJUserInfo sharedUserInfo].user_id forKey:@"user_id"];
    
    [self commitReq:params];
}

-(void)commitReq:(NSDictionary*)params
{
    [YDJProgressHUD showDefaultProgress:self.view];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        
        [YDJProgressHUD hideDefaultProgress:self.view];
        [YDJProgressHUD showTextToast:@"已经提交审核，请耐心等待" onView:self.view];
        [Utils delayWithDuration:2.0f DoSomeThingBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^{
        [YDJProgressHUD hideDefaultProgress:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 这里很恶心，问产品去
    if([Utils checkLogin])
    {
        if(indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 10)
        {
            SJPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCellID];
            if(indexPath.row == 3)
            {
                [cell configUI:_titleArr[indexPath.row] rightText:(_levelId == -1)?_placeTitleArr[indexPath.row]:cell.rightLabel.text isAddLength:indexPath.row == 10?YES:NO];
                cell.rightLabel.textColor  = (_levelId == -1)?RGBHEX(0x9B9B9B):Theme_TextMainColor;
            }
            else if (indexPath.row == 5)
            {
                [cell configUI:_titleArr[indexPath.row] rightText:(_sexId == -1)?_placeTitleArr[indexPath.row]:cell.rightLabel.text isAddLength:indexPath.row == 10?YES:NO];
                cell.rightLabel.textColor  = (_sexId == -1)?RGBHEX(0x9B9B9B):Theme_TextMainColor;

            }
            else if(indexPath.row == 10)
            {
                [cell configUI:_titleArr[indexPath.row] rightText:(_sexId == -1)?_placeTitleArr[indexPath.row]:cell.rightLabel.text isAddLength:indexPath.row == 10?YES:NO];
                if(_picPath)
                {
                    cell.rightLabel.text = @"图片已上传";
                }
                cell.rightLabel.textColor = _picPath?Theme_MainColor:RGBHEX(0x9B9B9B);

            }
            return cell;
        }
        else if(indexPath.row == 9)
        {
            SJAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellID];
            [cell configUI:@"选择地区" vc:self];
            cell.endEditBlock = ^(NSString* comp0, NSString* comp1, NSString* comp2){
                _myCityStr = [NSString stringWithFormat:@"%@%@%@", comp0, comp1, comp2];
            };
            
            return cell;
        }
        else{
            SJTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configUI:_titleArr[indexPath.row] placeholder:_placeTitleArr[indexPath.row]];
            cell.kbBlock = ^(UITextField *textField)
            {
                CGPoint origin = textField.frame.origin;
                CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
                
                CGFloat kbtop = ScreenHeight - 260;
                if(point.y+64+44 > kbtop)
                {
                    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, point.y + 64 + 44 - kbtop + 260, 0)];
                }
                
            };
            switch (indexPath.row) {
                case 0:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _shangjiName = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 1:
                {
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.endBlock = ^(NSString *text)
                    {
                        _shangjiPhoneNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 2:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _shangjiWeixinNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 4:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _myName = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 6:
                {
                    cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
                    cell.endBlock = ^(NSString *text)
                    {
                        _myId = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 7:
                {
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.endBlock = ^(NSString *text)
                    {
                        _myPhoneNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 8:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _myWeixinNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                default:
                    break;
            }
            return cell;
        }

    }
    else
    {
        if(indexPath.row == 7)
        {
            SJLoginTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:loginTextFieldCellID];
            cell.vc = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configUI:@"手机号" placeholder:@"请输入手机号" showRightBtn:YES];
            SJWEAKSELF
            cell.textField.textAlignment = NSTextAlignmentRight;
            cell.getVerifyCodeBlock = ^{
                [weakSelf.view endEditing:YES];
            };
            cell.tfBlock = ^(NSString *text)
            {
                _myPhoneNum = text;
            };
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            return cell;
        }
        else if(indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 12)
        {
            SJPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCellID];
            if(indexPath.row == 3)
            {
                [cell configUI:_titleArr[indexPath.row] rightText:(_levelId == -1)?_placeTitleArr[indexPath.row]:cell.rightLabel.text isAddLength:indexPath.row == 12?YES:NO];
                cell.rightLabel.textColor  = (_levelId == -1)?RGBHEX(0x9B9B9B):Theme_TextMainColor;
            }
            else if (indexPath.row == 5)
            {
                [cell configUI:_titleArr[indexPath.row] rightText:(_sexId == -1)?_placeTitleArr[indexPath.row]:cell.rightLabel.text isAddLength:indexPath.row == 12?YES:NO];
                cell.rightLabel.textColor  = (_sexId == -1)?RGBHEX(0x9B9B9B):Theme_TextMainColor;
                
            }
            else if(indexPath.row == 12)
            {
                [cell configUI:_titleArr[indexPath.row] rightText:(_sexId == -1)?_placeTitleArr[indexPath.row]:cell.rightLabel.text isAddLength:indexPath.row == 12?YES:NO];
                if(_picPath)
                {
                    cell.rightLabel.text = @"图片已上传";
                }
                cell.rightLabel.textColor = _picPath?Theme_MainColor:RGBHEX(0x9B9B9B);
                
            }
            return cell;
        }
        else if(indexPath.row == 11)
        {
            SJAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellID];
            cell.endEditBlock = ^(NSString* comp0, NSString* comp1, NSString* comp2){
                _myCityStr = [NSString stringWithFormat:@"%@%@%@", comp0, comp1, comp2];
            };
            
            return cell;
        }
        else{
            SJTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configUI:_titleArr[indexPath.row] placeholder:_placeTitleArr[indexPath.row]];
            cell.kbBlock = ^(UITextField *textField)
            {
                CGPoint origin = textField.frame.origin;
                CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
                
                CGFloat kbtop = ScreenHeight - 260;
                if(point.y+64+44 > kbtop)
                {
                    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, point.y + 64 + 44 - kbtop + 260, 0)];
                }
                
            };
            switch (indexPath.row) {
                case 0:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _shangjiName = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 1:
                {
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.endBlock = ^(NSString *text)
                    {
                        _shangjiPhoneNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 2:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _shangjiWeixinNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 4:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _myName = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 6:
                {
                    cell.textField.keyboardType = UIKeyboardTypeASCIICapable;

                    cell.endBlock = ^(NSString *text)
                    {
                        _myId = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 8:
                {
                    cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
                    cell.endBlock = ^(NSString *text)
                    {
                        _myVerifyCode = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                case 9:
                {
                    cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
                    cell.endBlock = ^(NSString *text)
                    {
                        _myPwd = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                    
                case 10:
                {
                    cell.endBlock = ^(NSString *text)
                    {
                        _myWeixinNum = text;
                        [UIView animateWithDuration:0.3f animations:^{
                            [self.tableView setContentInset:UIEdgeInsetsZero];
                        }];
                    };
                }
                    break;
                default:
                    break;
            }
            return cell;
        }

    }
    
    return [[UITableViewCell alloc]init];
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
    
    if([Utils checkLogin])
    {
        if(indexPath.row == 3)
        {
            SJPickerCell *pickerCell = [tableView cellForRowAtIndexPath:indexPath];
            [ActionSheetStringPicker showPickerWithTitle:@"经销商级别" rows:@[@"总代", @"省代", @"市代", @"健康顾问"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                pickerCell.rightLabel.text = selectedValue;
                pickerCell.rightLabel.textColor = Theme_TextMainColor;
                _levelId = selectedIndex;
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }
        else if(indexPath.row == 5)
        {
            SJPickerCell *pickerCell = [tableView cellForRowAtIndexPath:indexPath];
            
            [ActionSheetStringPicker showPickerWithTitle:@"性别" rows:@[@"男", @"女"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                pickerCell.rightLabel.text = selectedValue;
                _sexId = selectedIndex;
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }
        else if(indexPath.row == 9)
        {
            SJAddressCell *addressCell = [tableView cellForRowAtIndexPath:indexPath];
            [self.view endEditing:YES];
            addressCell.endEditBlock = ^(NSString* comp0, NSString* comp1, NSString* comp2)
            {
                if(comp0 && comp1 && comp2)
                {
                    _myCity = @[comp0, comp1, comp2];
                }
            };
            [addressCell showPickView];
        }
        else if(indexPath.row == 10)
        {
            SJUploadPhotoVC *vc = [[SJUploadPhotoVC alloc]initWithNibName:@"SJUploadPhotoVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        if(indexPath.row == 3)
        {
            SJPickerCell *pickerCell = [tableView cellForRowAtIndexPath:indexPath];
            [ActionSheetStringPicker showPickerWithTitle:@"经销商级别" rows:@[@"总代", @"省代", @"市代", @"健康顾问"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                pickerCell.rightLabel.text = selectedValue;
                
                _levelId = selectedIndex;
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }
        else if(indexPath.row == 5)
        {
            SJPickerCell *pickerCell = [tableView cellForRowAtIndexPath:indexPath];
            
            [ActionSheetStringPicker showPickerWithTitle:@"性别" rows:@[@"男", @"女"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                pickerCell.rightLabel.text = selectedValue;
                _sexId = selectedIndex;
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }
        else if(indexPath.row == 11)
        {
            SJAddressCell *addressCell = [tableView cellForRowAtIndexPath:indexPath];
            [self.view endEditing:YES];
            addressCell.endEditBlock = ^(NSString* comp0, NSString* comp1, NSString* comp2)
            {
                if(comp0 && comp1 && comp2)
                {
                    _myCity = @[comp0, comp1, comp2];
                }
            };
            [addressCell showPickView];
        }
        else if(indexPath.row == 12)
        {
            SJUploadPhotoVC *vc = [[SJUploadPhotoVC alloc]initWithNibName:@"SJUploadPhotoVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



@end
