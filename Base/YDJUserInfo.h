//
//  YDJUserInfo.h
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/12.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDJUserInfoModel.h"

@interface YDJUserInfo : NSObject

@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *head;
@property (nonatomic, copy)NSString *token_type;
@property (nonatomic, copy)NSString *user_type;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *validation;
@property (nonatomic, copy)NSString *news;



+(instancetype)sharedUserInfo;

-(void)updateInfo:(YDJUserInfoModel*)model;

@end
