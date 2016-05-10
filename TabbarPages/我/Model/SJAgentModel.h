//
//  SJAgentModel.h
//  Jscancode
//
//  Created by 范茂羽 on 16/5/10.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseModel.h"

@interface SJAgentModel : SJBaseModel

@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *weixin;
@property (nonatomic, copy)NSString *validation;
@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *area;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *id_card;
@property (nonatomic, copy)NSString *id_img;

@property (nonatomic, copy)NSString *pre_name;
@property (nonatomic, copy)NSString *pre_phone;
@property (nonatomic, copy)NSString *pre_weixin;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *end_time;

@property (nonatomic, copy)NSString *goods_num;
@property (nonatomic, copy)NSString *head;
@property (nonatomic, copy)NSString *points;
@end
