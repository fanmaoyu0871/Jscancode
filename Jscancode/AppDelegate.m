//
//  AppDelegate.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "AppDelegate.h"
#import "SJTabBarController.h"
#import "SJLoginVC.h"
#import "SJNavigationController.h"
#import "SJLoginVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //启动页延时
    [NSThread sleepForTimeInterval:2.0f];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //umeng init
    [UMSocialData setAppKey:UMengAppKey];
    //wechat init
    [UMSocialWechatHandler setWXAppId:WeChatAppID appSecret:WeChatSecret url:nil];

    
    //读取本地存储的个人信息
    [[YDJCoreDataManager defaultCoreDataManager]queryTable:Table_UserInfo resultModel:@"YDJUserInfoModel"];
    
    if([YDJUserInfo sharedUserInfo].token) //有token我就token登录
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.login.by.token", @"name", nil];
        [QQNetworking requestDataWithQQFormatParam:params view:nil success:^(NSDictionary *dic) {
            NSDictionary *data = dic[@"data"];
            YDJUserInfoModel *model = [[YDJUserInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:data];
            model.token = [YDJUserInfo sharedUserInfo].token;
            //更新数据库
            [[YDJCoreDataManager defaultCoreDataManager]deleteTable:Table_UserInfo];
            [[YDJCoreDataManager defaultCoreDataManager]insertTable:Table_UserInfo model:model];
        } failure:^{
            [self visitorLoginReq];
        }];
    }
    else
    {
        [self visitorLoginReq];
    }

    
//    SJLoginVC *vc = [[SJLoginVC alloc] init];
//    self.window.rootViewController = vc;
    SJTabBarController *tabbarVC = [[SJTabBarController alloc]init];
    self.window.rootViewController = tabbarVC;
    
//    SJLoginVC *loginVC = [[SJLoginVC alloc]initWithNibName:@"SJLoginVC" bundle:nil];
//    SJNavigationController *navVC = [[SJNavigationController alloc]initWithRootViewController:loginVC];
//    self.window.rootViewController = navVC;
    
    return YES;
}

- (void)visitorLoginReq
{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSDictionary *dic = @{@"name": @"scancode.sys.add.tourist", @"serial_no":identifierForVendor};
    [QQNetworking requestDataWithQQFormatParam:dic view:nil success:^(NSDictionary *response) {
        NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊%@＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊", response);
        NSDictionary *data = response[@"data"];
        YDJUserInfoModel *model = [[YDJUserInfoModel alloc]init];
        [model setValuesForKeysWithDictionary:data];
        
        //更新数据库
        [[YDJCoreDataManager defaultCoreDataManager]deleteTable:Table_UserInfo];
        [[YDJCoreDataManager defaultCoreDataManager]insertTable:Table_UserInfo model:model];
        //[self loginSuccess];
    }failure:^{
        
    } needToken:false];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[YDJCoreDataManager defaultCoreDataManager] saveContext];

}


@end
