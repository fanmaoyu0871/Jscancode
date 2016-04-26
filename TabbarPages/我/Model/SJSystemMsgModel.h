//
//  SJSystemMsgModel.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/25.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseModel.h"

@interface SJSystemMsgModel : SJBaseModel

@property (nonatomic, copy)NSString *tmpId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *head;

@end
