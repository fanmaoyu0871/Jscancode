//
//  YDJUserInfoModel.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/27.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseModel.h"

@interface YDJUserInfoModel : SJBaseModel
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *head;
@property (nonatomic, copy)NSString *token_type;
@property (nonatomic, copy)NSString *user_type;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *validation;
@property (nonatomic, copy)NSString *news;

@end
