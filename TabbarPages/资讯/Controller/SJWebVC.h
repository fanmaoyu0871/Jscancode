//
//  SJWebVC.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseViewController.h"

typedef NS_ENUM(NSInteger, URLTYPE)
{
    Wodejifen = 0,
    Lianxiwomen,
    Yonghuxuzhi,
    ZixunAd
};

@interface SJWebVC : SJBaseViewController

@property (nonatomic, copy)NSString *urlStr;

@property (nonatomic, assign)URLTYPE urlType;


@end
