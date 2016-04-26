//
//  SJAdModel.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/26.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseModel.h"

@interface SJAdModel : SJBaseModel

@property (nonatomic, copy)NSString *tmpId;
@property (nonatomic, copy)NSString *brief;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *priority;

@end
