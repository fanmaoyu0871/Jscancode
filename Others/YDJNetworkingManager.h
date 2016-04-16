//
//  YDJNetworkingManager.h
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/8.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, ResponseType)
//{
//    CodeType = 1,
//    DataType = 2,
//};

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailBlock)(NSError *error);


@interface YDJNetworkingManager : NSObject

+(instancetype)sharedManager;

-(void)PostUrl:(NSString*)urlStr model:(NSString*)model method:(NSString*)method parameters:(NSDictionary*)parameters showView:(UIView*)view successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

@end
