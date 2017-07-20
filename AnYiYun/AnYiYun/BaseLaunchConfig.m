//
//  BaseLaunchConfig.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseLaunchConfig.h"
#import "LoadingViewController.h"
#import "LoginViewController.h"
#import "FirstLaunchView.h"

@implementation BaseLaunchConfig

+ (void)launchingFlowConfig
{
        //临时测试 需删除
    [BaseCacheHelper setBOOLValue:YES forKey:kFirstApp];
    
    
        //实时网络检测
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kBaseReachabilityChangedNotification
                                               object:nil];
    
    BaseReachability *internetConnectionReach = [BaseReachability reachabilityForInternetConnection];
    NSString  *networkStatusString = @(internetConnectionReach.currentReachabilityStatus).stringValue;
    DLog(@"初始网络状态:%@",networkStatusString);
    [BaseCacheHelper setValue:networkStatusString forKey:kNotifierNetWork];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkStatusChangeNotification object:nil];
    [internetConnectionReach startNotifier];
    
    [BaseCacheHelper getPersonInfo];
    
    [self setRootViewByCacheInfo];

}

+ (void)reachabilityChanged:(NSNotification *)notification
{
    BaseReachability *reach = [notification object];
    NetworkStatus temp = reach.currentReachabilityStatus;
    
    NSString  *networkStatusString = @(temp).stringValue;
    DLog(@"网络状态变化:%@",networkStatusString);
   [BaseCacheHelper setValue:networkStatusString forKey:kNotifierNetWork];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkStatusChangeNotification object:nil];
}


+ (void)setRootViewByCacheInfo
{
    BOOL everLoginSuccess = [PersonInfo shareInstance].loginSuccess;
    if (everLoginSuccess==YES)
        {
        NSString *account = [BaseHelper filterNullObj:[PersonInfo shareInstance].accountID];
        NSString *password = [BaseHelper filterNullObj:[PersonInfo shareInstance].password];
        
        LoadingViewController *loadingVC = [[LoadingViewController alloc] initWithCacheAccount:account password:password];
        BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loadingVC];
        kWindow.rootViewController = navigation;
    }
    else
        {
            //默认根视图是登录页面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        kWindow.rootViewController = navigation;
        
            //首次登录,首次启动APP（启动页面）
        BOOL isFirstApp = [BaseCacheHelper getBOOLValueForKey:kFirstApp];
        if (!isFirstApp) {
            FirstLaunchView *launchV = [[FirstLaunchView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) delegate:self];
            [kWindow.rootViewController.view addSubview:launchV];
        }
    }
}


+ (void)createFolder
{
    [BaseCacheHelper createFolder:PATH_AT_CACHEDIR(kUserCacheImageFolder) isDirectory:YES];
    [BaseCacheHelper createFolder:PATH_AT_CACHEDIR(kUserCacheVideoFolder) isDirectory:YES];
    [BaseCacheHelper createFolder:PATH_AT_CACHEDIR(kUserCacheAudioFolder) isDirectory:YES];
}

+(void)setSharedURLCache
{
        //内存
    int cacheSizeMemory = 1*1024*1024;
    int cacheSizeDisk = 5*1024*1024;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:
                               cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
}


@end
