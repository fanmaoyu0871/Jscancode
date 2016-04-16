//
//  YDJUserInfo.h
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/12.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDJUserInfo : NSObject

@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy)NSString *head_pic_path;
@property (nonatomic, copy)NSString *nick_name;

+(instancetype)sharedUserInfo;

@end
