//
//  QQNetworking.h
//  QQiao
//
//  Created by mq on 16/1/11.
//  Copyright © 2016年 menq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, MIMETYPE)
{
    Image,
    Video
};

@interface QQNetworking : NSObject

+ (NSString *) URL;
+ (AFHTTPSessionManager *)manager;
// 封装的工具方法
+ (void)requestWithParam:(NSDictionary *)dic
                 success:(void (^)(NSURLSessionDataTask *task, NSDictionary *response))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
+ (NSDictionary *)formRequestJSON:(NSString *)param;
+ (NSDictionary *)formRequestJSONWithToken:(NSString *)param;
+ (NSString *)dictionaryToUrlTypeString:(NSDictionary *)dic;


//上传图片/视频方法
+ (void)requestUploadFormdataParam:(NSDictionary*)dic mediaData:(id)obj mediaType:(MIMETYPE)type view:(UIView*)view success:(void (^)(NSDictionary *))success failure:(void (^)())failure;


// 用这个方法来统一处理网络请求，请求错误也会统一提示。默认带有token;
+ (void)requestDataWithQQFormatParam:(NSDictionary *)dic view:(UIView*)view
                             success:(void (^)(NSDictionary *dic)) success failure:(void (^)())failure;
//同上，选择带不带token
+ (void)requestDataWithQQFormatParam:(NSDictionary *)dic view:(UIView*)view
                             success:(void (^)(NSDictionary *))success failure:(void (^)())failure
                           needToken:(BOOL)needToken;

+ (void)IBPromptViewWithText:(NSString *)text inView:(UIView *)view;

@end
