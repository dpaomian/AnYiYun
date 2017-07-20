//
//  LoginManager.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoginManager.h"
#import "RootTabBarViewController.h"
#import "LoginViewController.h"
@implementation LoginManager

+ (void)loginWithAccount:(NSString *)account
                    inVC:(UIViewController *)vc
completionBlockWithSuccess:(requestBlockSuccess)success
                 failure:(requestFailure)failure
{
        //登录成功
    [PersonInfo shareInstance].loginSuccess = YES;
    [BaseCacheHelper setPersonInfo];
     success();
}

+ (void)setRootViewAfterPlatFormLogin
{
    MAIN(^{
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    });
 
    BOOL isLoginSuccess = [PersonInfo shareInstance].loginSuccess;
    if (isLoginSuccess)
        {
        RootTabBarViewController *tabVC = [RootTabBarViewController init];
        kWindow.rootViewController = tabVC;
        }
    else
        {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        kWindow.rootViewController = navigation;
        }
}

@end
