//
//  SJDistributeDongtaiVC.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseViewController.h"

typedef NS_ENUM(NSInteger, DongtaiType)
{
    photoType = 0,
    videoType,
};

@interface SJDistributeDongtaiVC : SJBaseViewController

@property (nonatomic, assign)DongtaiType dongtaiType;

@property (nonatomic, copy)NSArray *photoArray;

@property (nonatomic, copy)NSURL *videoUrl;


@end
