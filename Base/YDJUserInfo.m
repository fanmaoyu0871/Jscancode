//
//  YDJUserInfo.m
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/12.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "YDJUserInfo.h"

@implementation YDJUserInfo

+(instancetype)sharedUserInfo
{
    static dispatch_once_t once;
    static YDJUserInfo *userInfo;
    dispatch_once(&once, ^{
        userInfo = [[self alloc]init];
    });
    
    return userInfo;
}


@end
