//
//  YDJCoreDataManager.h
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/12.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YDJCoreDataManager : NSObject

+(instancetype)defaultCoreDataManager;

#pragma mark - 插入数据
- (NSError*)insertTable:(NSString*)tableName model:(id)model;

#pragma mark - 删除表中所有数据
- (NSError*)deleteTable:(NSString*)tableName;

#pragma mark - 查询数据
- (id)queryTable:(NSString*)tableName resultModel:(NSString*)modelName;

#pragma mark - 更新字段
- (NSError*)updateTable:(NSString*)tableName key:(NSString*)key value:(NSString*)value needKey:(NSString*)needKey newValue:(NSString*)newValue;


- (void)saveContext;

@end
