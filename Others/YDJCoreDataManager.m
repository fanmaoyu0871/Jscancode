//
//  YDJCoreDataManager.m
//  YiDaJian
//
//  Created by 范茂羽 on 16/4/12.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "YDJCoreDataManager.h"
#import <CoreData/CoreData.h>
#import "YDJUserInfoModel.h"

@interface YDJCoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation YDJCoreDataManager

+(instancetype)defaultCoreDataManager
{
    static dispatch_once_t once;
    static YDJCoreDataManager *manager;
    
    dispatch_once(&once, ^{
        manager = [[self alloc]init];
    });
    
    return manager;
}

#pragma mark - Core Data stack
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.shiguofan.www.YiDaJian" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Jscancode" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YiDaJian.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - 插入数据
- (NSError*)insertTable:(NSString*)tableName model:(id)model
{
    @synchronized(self) {
        
        if([model isKindOfClass:[YDJUserInfoModel class]])
        {
            YDJUserInfoModel *userInfoModel = model;
            NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];

            [person setValue:userInfoModel.token forKey:@"token"];
            [person setValue:userInfoModel.user_id forKey:@"user_id"];
            [person setValue:userInfoModel.name forKey:@"name"];
            [person setValue:userInfoModel.head forKey:@"head"];
            [person setValue:userInfoModel.token_type forKey:@"token_type"];
            [person setValue:userInfoModel.user_type forKey:@"user_type"];
            [person setValue:userInfoModel.level forKey:@"level"];
            //更新个人信息单例
            [[YDJUserInfo sharedUserInfo] updateInfo:userInfoModel];
            
            NSError *error = nil;
            [self.managedObjectContext save:&error];
            
            return error;
        }
        
        return nil;
    }
}

#pragma mark - 更新字段
- (NSError*)updateTable:(NSString*)tableName key:(NSString*)key value:(NSString*)value needKey:(NSString*)needKey newValue:(NSString*)newValue
{
    @synchronized(self) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSPredicate * pre = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@==%@", key, value]];
        [fetchRequest setPredicate:pre];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *resultArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if(error == nil)
        {
            NSManagedObject *obj = [resultArr firstObject];
            [obj setValue:newValue forKey:needKey];
            
            [self.managedObjectContext save:&error];
            return error;
        }
        
        return error;
    }
}


#pragma mark - 删除数据
- (NSError*)deleteTable:(NSString*)tableName
{
    @synchronized(self) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setIncludesPropertyValues:NO];
        [request setEntity:entity];
        
        NSError *error = nil;
        NSArray *datas = [context executeFetchRequest:request error:&error];
        if (!error && datas && [datas count])
        {
            for (NSManagedObject *obj in datas)
            {
                [context deleteObject:obj];
            }
            if (![context save:&error])
            {
                NSLog(@"error:%@",error);
            }
        }
        
        return error;
    }
}

#pragma mark - 查询数据
- (id)queryTable:(NSString*)tableName resultModel:(NSString*)modelName;
{
    @synchronized(self) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *resultArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                
        if(error == nil)
        {
            for(NSManagedObject *obj in resultArr)
            {
                if(resultArr.count == 1 && [modelName isEqualToString:@"YDJUserInfoModel"])
                {
                    YDJUserInfoModel *userInfoModel = [[YDJUserInfoModel alloc]init];
                    userInfoModel.token = [obj valueForKey:@"token"];
                    userInfoModel.user_id = [obj valueForKey:@"user_id"];
                    userInfoModel.name = [obj valueForKey:@"name"];
                    userInfoModel.head = [obj valueForKey:@"head"];
                    userInfoModel.token_type = [obj valueForKey:@"token_type"];
                    userInfoModel.user_type = [obj valueForKey:@"user_type"];
                    userInfoModel.level = [obj valueForKey:@"level"];

                    //更新个人信息单例
                    [[YDJUserInfo sharedUserInfo] updateInfo:userInfoModel];
                    return userInfoModel;
                }
            }
            
        }
        
        return nil;
    }
}


@end
