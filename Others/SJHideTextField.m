//
//  SJHideTextField.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJHideTextField.h"

@implementation SJHideTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIView *accessView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 29)];
    accessView.backgroundColor = [UIColor clearColor];
    UIButton *keyboardDownBtn = [[UIButton alloc]initWithFrame:CGRectMake(accessView.width-36, 0, 36, 29)];
    [keyboardDownBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_btn_hide"] forState:UIControlStateNormal];
    [keyboardDownBtn addTarget:self action:@selector(keyboardDown) forControlEvents:UIControlEventTouchUpInside];
    [accessView addSubview:keyboardDownBtn];
    self.inputAccessoryView = accessView;
}

-(void)keyboardDown
{
    [self resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
