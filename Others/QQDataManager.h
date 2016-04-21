//
//  QQDataManager.h
//  QQiao
//
//  Created by mq on 16/1/13.
//  Copyright © 2016年 menq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQDataManager : NSObject
+ (instancetype) manager;

@property(nonatomic, strong)NSString *token;
@property(nonatomic, strong)NSNumber *userId;


- (void)logout;

@end
