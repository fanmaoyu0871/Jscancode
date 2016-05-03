//
//  SJTextFieldCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/20.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJLoginTextFieldCell.h"

@interface SJLoginTextFieldCell ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    NSInteger _seconds;
}
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingCons;

@end

@implementation SJLoginTextFieldCell

-(void)configUI:(NSString*)leftText placeholder:(NSString*)ph showRightBtn:(BOOL)isShow
{
    self.rightBtn.layer.cornerRadius = 5;
    self.rightBtn.layer.borderWidth = 1;
    self.rightBtn.layer.borderColor = Theme_MainColor.CGColor;
    self.rightBtn.layer.masksToBounds = YES;
    
    self.leftLabel.text = leftText;
    self.textField.placeholder = ph;
    self.textField.delegate = self;
    
    self.trailingCons.constant = isShow?120:20;
    self.rightBtn.hidden = isShow?NO:YES;
    
}

#pragma mark - 获取验证码请求
-(void)reqGetVerifyCode
{
    if(self.textField.text.length == 0 || self.textField.text.length != 11)
    {
        [YDJProgressHUD showTextToast:@"手机号码：11个数字" onView:self.vc.view];
        return;
    }
    
    [QQNetworking requestDataWithQQFormatParam:@{@"name":@"scancode.sys.register.sms.send", @"mobile":self.textField.text} view:self.vc.view success:^(NSDictionary *dic) {
        [YDJProgressHUD showTextToast:@"验证码发送成功" onView:self.vc.view];
        
        _seconds = 60;
        //创建定时器
        if(_timer == nil)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            [_timer setFireDate:[NSDate distantPast]];
        }
        
        //禁用掉btn
        self.rightBtn.enabled = NO;
        
    } failure:^{
        [YDJProgressHUD showTextToast:@"验证码发送失败" onView:self.vc.view];
    } needToken:NO];
    
}

- (IBAction)getVerifyCodeBtnAction:(id)sender
{
    
    if(self.getVerifyCodeBlock)
    {
        [self reqGetVerifyCode];
    }

}

//定时器事件
-(void)updateTimer
{
    _seconds--;
    NSString *title = [NSString stringWithFormat:@"已发送(%lds)", (long)_seconds];
    [self.rightBtn setTitle:title forState:UIControlStateDisabled];
    
    if(_seconds <= 0)
    {
        self.rightBtn.enabled = YES;
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.tfBlock)
    {
        self.tfBlock(textField.text);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
