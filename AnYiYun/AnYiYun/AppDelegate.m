//
//  AppDelegate.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "RootTabBarViewController.h"
#import "BaseLaunchConfig.h"
#import "FilterCollectionView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "YYTools.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//极光推送相关
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([NSArray arrayWithArray:[defaults objectForKey:@"YYMS"]].count==0) {
        NSArray *array = @[@{@"idex":@"0",
                           @"isSelected":@"1",
                           @"needInput":@"1",
                           @"text1":@"超过",
                           @"textFieldText1":@"500",
                           @"text2":@"条，清理最早的",
                           @"textFieldText2":@"300",
                           @"text3":@"条",
                           @"maxLength":@"3",
                           @"field1MixValue":@"50",
                           @"field1MaxValue":@"500",
                           @"field2MixValue":@"10",
                           @"field2MaxValue":@"300"},
                         @{@"idex":@"1",
                           @"isSelected":@"0",
                           @"needInput":@"1",
                           @"text1":@"超过",
                           @"textFieldText1":@"90",
                           @"text2":@"天，清理最早的",
                           @"textFieldText2":@"30",
                           @"text3":@"天",
                           @"maxLength":@"2",
                           @"field1MixValue":@"5",
                           @"field1MaxValue":@"90",
                           @"field2MixValue":@"5",
                           @"field2MaxValue":@"50"},
                         @{@"idex":@"2",
                           @"isSelected":@"0",
                           @"needInput":@"0",
                           @"text1":@"我自己处理，无需自动清理",
                           @"textFieldText1":@"",
                           @"text2":@"",
                           @"textFieldText2":@"",
                           @"text3":@"",
                           @"maxLength":@"0",
                           @"field1MixValue":@"0",
                           @"field1MaxValue":@"0",
                           @"field2MixValue":@"0",
                           @"field2MaxValue":@"0"}
                         ];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:array forKey:@"YYMS"];
        [defaults synchronize];
    } else {
        DLog(@"%@",[defaults objectForKey:@"YYMS"]);
    }
    /*!高德地图初始化，重要代码，勿动*/
    [AMapServices sharedServices].apiKey = @"94c9e6d0c24fd53d43e09d961850a75e";
    
    
    /*!极光推送初始化，重要代码，勿动*/
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"433db554df122871cc77b411"
                          channel:@"App Store"
                 apsForProduction:[pushProduction boolValue]
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            DLog(@"registrationID获取成功：%@",registrationID);
        }
        else
        {
            DLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [BaseLaunchConfig launchingFlowConfig];

    /*!程序初始化，重要代码，勿动*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[AnYiYunApplication applicationAlloc] applicationInit:^(NSString *string) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
                [kWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                return ;
            });
        }];
    });
    
    /*初始化筛选框*/
//    [FilterCollectionView shareFilter];
    
    return YES;
}

#pragma mark -  推送
-(void)reloadMessageNotification
{
    //刷新是否有未读消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMessageIsRead" object:@"1"];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    DLog(@"收到推送 自定义消息  %@",userInfo);
    
    //刷新是否有未读消息
    [self reloadMessageNotification];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    DLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    [self reloadMessageNotification];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    DLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        [self reloadMessageNotification];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        [self reloadMessageNotification];
        
    }
    else {
        // 判断为本地通知
        DLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [self reloadMessageNotification];
        
    }
    else {
        // 判断为本地通知
        DLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


@end
