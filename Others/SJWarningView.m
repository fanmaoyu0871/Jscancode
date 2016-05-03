//
//  SJWarningView.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/4.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJWarningView.h"
#import "AppDelegate.h"

@implementation SJWarningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        bgView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.4f];
        [self addSubview:bgView];
        
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth - 50*2, 220)];
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.layer.cornerRadius = 5;
        centerView.layer.masksToBounds = YES;
        [bgView addSubview:centerView];
        centerView.centerX = ScreenWidth/2;
        
        UILabel *warnLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:24.0f fontColor:RGBHEX(0xD0021B) text:@"警告"];
        [centerView addSubview:warnLabel];
        warnLabel.top = 10;
        warnLabel.centerX = centerView.width/2;
        
        UIImageView *iv = [[UIImageView alloc]init];
        iv.image = [UIImage imageNamed:@"jinggao"];
        [centerView addSubview:iv];
        [iv sizeToFit];
        iv.centerX = centerView.width/2;
        iv.top = warnLabel.bottom + 10;
        
        UILabel *label1 = [UILabel labelWithFontName:Theme_MainFont fontSize:13.0f fontColor:Theme_TextMainColor text:@"请勿宣传其他产品"];
        [centerView addSubview:label1];
        label1.top = iv.bottom + 10;
        label1.centerX = centerView.width/2;
        
        UILabel *label2 = [UILabel labelWithFontName:Theme_MainFont fontSize:13.0f fontColor:Theme_TextMainColor text:@"发布色情暴力信息"];
        [centerView addSubview:label2];
        label2.top = label1.bottom + 10;
        label2.centerX = centerView.width/2;
        
        UILabel *label3 = [UILabel labelWithFontName:Theme_MainFont fontSize:13.0f fontColor:Theme_TextMainColor text:@"一经发现，永久查封"];
        [centerView addSubview:label3];
        label3.top = label2.bottom + 10;
        label3.centerX = centerView.width/2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [bgView addGestureRecognizer:tap];

    }
    return self;
}

-(void)tapAction
{
    [self dismiss];
    
    if(self.tapBlock)
    {
        self.tapBlock();
    }
}

-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows lastObject];
    
    [keyWindow addSubview:self];
}

-(void)dismiss
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
