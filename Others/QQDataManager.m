//
//  QQDataManager.m
//  QQiao
//
//  Created by mq on 16/1/13.
//  Copyright © 2016年 menq.com. All rights reserved.
//

#import "QQDataManager.h"
static QQDataManager *instance = nil;
@implementation QQDataManager

+ (instancetype) manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QQDataManager alloc] init];
    });
    return instance;
}

- (NSString *)token{
   return  [[NSUserDefaults standardUserDefaults] valueForKey:@"http_token"];
}

- (void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"http_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)userId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
}

- (void)setUserId:(NSNumber *)userId{
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
