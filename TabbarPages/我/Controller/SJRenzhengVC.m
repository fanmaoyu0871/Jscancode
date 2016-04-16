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

#define textFieldCellID @"textFieldCellID"
#define pickerCellID @"pickerCellID"

@interface SJRenzhengVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
    NSArray *_placeTitleArr;
    
    UIButton *_binggoBtn;
    UIButton *_commitBtn;
    
    NSString *_shangjiName;
    NSString *_shangjiPhoneNum;
    NSString *_shangjiWeixinNum;
    NSString *_myName;
    NSString *_myId;
    NSString *_myPhoneNum;
    NSString *_myWeixinNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJRenzhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"认证经销商";
    
    // 3, 5, 9,10 picker
    _titleArr = @[@"上级经销商姓名", @"上级经销商手机号", @"上级经销商微信号", @"经销商级别选择", @"您的真实姓名", @"性别", @"您的身份证号", @"手机号", @"微信号", @"地区", @"上传您的手持身份证照片"];
    _placeTitleArr = @[@"请输入姓名", @"请输入上级经销商手机号", @"请输入上级经销商微信号", @"选择经销商级别", @"真实姓名", @"选择性别", @"请输入身份证号", @"请输入手机号", @"请输入微信号", @"选择地区", @"上传照片"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJTextFieldCell" bundle:nil] forCellReuseIdentifier:textFieldCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJPickerCell" bundle:nil] forCellReuseIdentifier:pickerCellID];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    [self createFooterView];
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
    [_commitBtn setTitle:@"认证成为经销商" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_commitBtn];
    _commitBtn.center = CGPointMake(ScreenWidth/2, xieyiBtn.bottom + 10);
    _commitBtn.enabled = NO;
    
    self.tableView.tableFooterView = bgView;
}

-(void)bingoBtnAction:(UIButton*)btn
{
    btn.selected = !btn.isSelected;
}

#pragma mark - 协议按钮
-(void)xieyiBtnAction
{
    NSLog(@"进入协议");
}

#pragma mark - 提交按钮事件
-(void)commitBtnAction
{
    
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
    if(indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 9 || indexPath.row == 10)
    {
        SJPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCellID];
        [cell configUI:_titleArr[indexPath.row] rightText:_placeTitleArr[indexPath.row] isAddLength:indexPath.row == 10?YES:NO];
        cell.rightLabel.textColor = indexPath.row == 10?Theme_MainColor:RGBHEX(0x9B9B9B);
        return cell;
    }
    else
    {
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
                };
            }
                break;
            case 1:
            {
                cell.endBlock = ^(NSString *text)
                {
                    _shangjiPhoneNum = text;
                };
            }
                break;
            case 2:
            {
                cell.endBlock = ^(NSString *text)
                {
                    _shangjiWeixinNum = text;
                };
            }
                break;
            case 4:
            {
                cell.endBlock = ^(NSString *text)
                {
                    _myName = text;
                };
            }
                break;
            case 6:
            {
                cell.endBlock = ^(NSString *text)
                {
                    _myId = text;
                };
            }
                break;
            case 7:
            {
                cell.endBlock = ^(NSString *text)
                {
                    _myPhoneNum = text;
                };
            }
                break;
            case 8:
            {
                cell.endBlock = ^(NSString *text)
                {
                    _myWeixinNum = text;
                };
            }
                break;
            default:
                break;
        }
        return cell;
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
}



@end
