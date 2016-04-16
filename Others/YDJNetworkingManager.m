//
//  YDJNetworkingManager.m
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/8.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "YDJNetworkingManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>

//与后台约定key
#define SIGN_KEY @"jskehysd*&^%dsfs"


@implementation YDJNetworkingManager

+(instancetype)sharedManager
{
    static dispatch_once_t once;
    static YDJNetworkingManager *manager;
    dispatch_once(&once, ^{
        manager = [[self alloc]init];
    });
    
    return manager;
}


//将字典转换为我们应用协议格式
-(NSDictionary *)formatDictionary:(NSDictionary*)dict model:(NSString*)model method:(NSString*)method
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutDict setObject:model forKey:@"model"];
    [mutDict setObject:method forKey:@"method"];
    
    //时间戳
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    [mutDict setObject:timeStr forKey:@"time"];
    
    NSMutableString *mutString = [NSMutableString string];
    
    //把字典排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    for (id nestedKey in [mutDict.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
        id nestedValue = mutDict[nestedKey];
        if (nestedValue) {
            [mutString appendFormat:@"%@-%@-", nestedKey, nestedValue];
        }
    }
    
    NSMutableString *tmpString = [NSMutableString stringWithString:mutString];
    [tmpString appendString:SIGN_KEY];
    
    NSString *sign = [NSString md5:tmpString];
    [mutString appendFormat:@"%@-%@", @"sign", sign];
    
    NSLog(@"mutString = %@", mutString);
    
    [mutDict setObject:sign forKey:@"sign"];
    
    return mutDict;
}



-(void)PostUrl:(NSString*)urlStr model:(NSString*)model method:(NSString*)method parameters:(NSDictionary*)parameters showView:(UIView*)view successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    NSDictionary *dict = [self formatDictionary:parameters model:model method:method];
    
    NSLog(@"requestParams = %@", dict);
    
    [manager POST:urlStr parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"repsonseObj = %@", obj);
            
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = obj;
                if(dict[@"code"])
                {
                    if([dict[@"code"] isEqualToString:@"succ"] && dict[@"data"])
                    {
                        if(successBlock)
                        {
                            successBlock(dict[@"data"]);
                        }
                    }
                    else
                    {
                        [YDJProgressHUD hideDefaultProgress:view];
                        [YDJProgressHUD showTextToast:dict[@"msg"] onView:view];
                    }
                }
                else
                {
                    if(dict[@"data"] && successBlock)
                    {
                        successBlock(dict[@"data"]);
                    }
                    else
                    {
                        [YDJProgressHUD hideDefaultProgress:view];
                        [YDJProgressHUD showTextToast:@"数据有误" onView:view];
                    }
                }
            }
            else
            {
                if(failBlock)
                {
                    [MBProgressHUD hideAllHUDsForView:view animated:YES];
                    [YDJProgressHUD showTextToast:@"数据有误" onView:view];
                    NSError *error;
                    failBlock(error);
                }
            }
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(failBlock)
            {
                [MBProgressHUD hideAllHUDsForView:view animated:YES];
                
                NSLog(@"error.localizedDescription = %@", error.localizedDescription);
                [YDJProgressHUD showTextToast:@"网络出错" onView:view];
                failBlock(error);
            }
        });
    }];
}



@end
