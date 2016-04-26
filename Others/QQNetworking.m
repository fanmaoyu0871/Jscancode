//
//  QQNetworking.m
//  QQiao
//
//  Created by mq on 16/1/11.
//  Copyright © 2016年 menq.com. All rights reserved.
//

#import "QQNetworking.h"
#import <Foundation/Foundation.h>
#import <Foundation/NSURLSession.h>
#import "DES3Util.h"
#import "QQDataManager.h"
@implementation QQNetworking

+ (NSString *)URL{
     return @"http://tangguyan.vicp.net/scancode/php/api";
}

+ (AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[QQNetworking URL] ]];
    return manager;
}
+ (void)requestWithParam:(NSDictionary *)dic
                 success:(void (^)(NSURLSessionDataTask *task, NSDictionary *response))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    AFHTTPSessionManager *manager = [QQNetworking manager];
    
    [manager POST:@"" parameters:dic success:^(NSURLSessionDataTask *task, id response){
        success(task, response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"网络错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
//        failure(task, error);
    }];
    
}
+ (NSDictionary *)formRequestJSON:(NSString *)param{
    NSLog(@"1111:%@",param);
    NSString *encode = [DES3Util encrypt:param];
    return @{@"data": encode};
}

+ (NSDictionary *)formRequestJSONWithToken:(NSString *)param{
    NSMutableString *result = [[NSMutableString alloc] initWithString:param];
    [result appendFormat:@"&token=%@",[QQDataManager manager].token];
    return [QQNetworking formRequestJSON:result];
}

+ (NSString *)dictionaryToUrlTypeString:(NSDictionary *)dic{
    NSMutableString *result = [[NSMutableString alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop){
        [result appendFormat:@"%@=%@&", key, value];
    }];
    [result deleteCharactersInRange:NSMakeRange([result length]-1, 1)];
    return result;
}

+ (void)requestDataWithQQFormatParam:(NSDictionary *)dic view:(UIView*)view success:(void (^)(NSDictionary *))success{
    [QQNetworking requestDataWithQQFormatParam:dic view:view success:success needToken:true];
}

+ (void)requestUploadFormdataParam:(NSDictionary*)dic mediaData:(NSData*)data mediaType:(MIMETYPE)type view:(UIView*)view success:(void (^)(NSDictionary *))success{
    
    AFHTTPSessionManager *manager = [QQNetworking manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *params = [QQNetworking dictionaryToUrlTypeString:dic];
    NSDictionary *dataJSON = [QQNetworking formRequestJSONWithToken:params];

    [manager POST:@"" parameters:dataJSON constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"userfile" fileName:type==Image?@"filename.jpeg":@"videoname.mov" mimeType:type==Image?@"image/*":@"video/*"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"repsonseObj = %@", obj);
        
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = obj;
            if (dict[@"success"]&&[dict[@"success"] isEqual:@1]) {
                success(dict);
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
        }
        else
        {
            [YDJProgressHUD hideDefaultProgress:view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [YDJProgressHUD hideDefaultProgress:view];
    }];
}

+ (void)requestDataWithQQFormatParam:(NSDictionary *)dic view:(UIView*)view success:(void (^)(NSDictionary *))success needToken:(BOOL)needToken{
    NSString *params = [QQNetworking dictionaryToUrlTypeString:dic];
    NSDictionary *dataJSON = needToken ? [QQNetworking formRequestJSONWithToken:params] : [QQNetworking formRequestJSON:params];
    [QQNetworking requestWithParam:dataJSON success:^(NSURLSessionTask *task, NSDictionary *JSON) {
        //处理数据
        NSLog(@"json:%@",JSON);
        if (JSON[@"success"]&&[JSON[@"success"] isEqual:@1]) {
            success(JSON);
        }else{
            [YDJProgressHUD hideDefaultProgress:view];
            [[[UIAlertView alloc] initWithTitle:@"网络错误" message:JSON[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
        [YDJProgressHUD hideDefaultProgress:view];
    }failure:^(NSURLSessionTask *task, NSError *error){
        NSLog(@"error:%@",error);
        // 异常处理第二层
        [YDJProgressHUD hideDefaultProgress:view];
    }];
}

+ (void)IBPromptViewWithText:(NSString *)text inView:(UIView *)view{
    /*MBProgressHUD *hdu = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hdu];
    hdu.mode = MBProgressHUDModeText;
    hdu.labelText = text;
    [hdu show:YES];
    [hdu hide:YES afterDelay:1.0f];*/
}

@end
