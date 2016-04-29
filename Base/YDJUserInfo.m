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

-(void)updateInfo:(YDJUserInfoModel*)model
{

    self.token = model.token;
    self.user_id = model.user_id;
    self.name = model.name;
    self.head = model.head;
    self.token_type = model.token_type;
    self.user_type = model.user_type;
    self.level = model.level;
    self.validation = model.validation;
    self.news = model.news;
}


@end
