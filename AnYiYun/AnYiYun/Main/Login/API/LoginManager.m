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

//极光推送相关
// 引入JPush功能所需头文件
#import "JPUSHService.h"
@implementation LoginManager

+ (void)loginWithAccount:(NSString *)account
                    inVC:(UIViewController *)vc
completionBlockWithSuccess:(requestBlockSuccess)success
                 failure:(requestFailure)failure
{
    NSString *accountString = [BaseHelper isSpaceString:[PersonInfo shareInstance].loginTextAccount andReplace:@""];
    
    if (accountString.length>0)
        {
        NSDictionary *param = @{@"userName":accountString,
                                @"psw":[PersonInfo shareInstance].password,
                                @"sign":@"iPhone"
                                };
        
        NSString *urlString = [NSString stringWithFormat:@"%@rest/androidLogin",BASE_PLAN_URL];
        __weak typeof(self) weakSelf = self;
        MAIN( ^{
            [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
        });
        if (![BaseAFNRequest checkNetworkStatus]) {
            [StatusBarOverlay initAnimationWithAlertString:@"网络异常,请检查网络是否可用！" theImage:nil];
            [weakSelf setRootViewAfterPlatFormLogin];
            return;
        }
        [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(NSDictionary *object){
            MAIN(^{
                [MBProgressHUD hideHUDForView:kWindow animated:YES];
            });
            DLog(@"平台登录  请求返回   打印时间");
            NSInteger errorCode = [object[@"errorCode"] integerValue];
            if (errorCode == 0)
                {
                    //平台登录成功，记录当前用户信息
                [[PersonInfo shareInstance] initWithDic:object];
                [PersonInfo shareInstance].loginSuccess = YES;
                [BaseCacheHelper setPersonInfo];
                
                [weakSelf operationAfterLogin];
                
                success();
                }
            else
                {
                [BaseCacheHelper releaseAllCache];
                [weakSelf setRootLoginView];
                [StatusBarOverlay initAnimationWithAlertString:@"登录失败" theImage:nil];
                }
            
        } failureBlock:^(NSError *error) {
            DLog(@"登录失败：%@",error);
            MAIN(^{
                [MBProgressHUD hideHUDForView:kWindow animated:YES];
                [StatusBarOverlay initAnimationWithAlertString:@"登录失败，请检查您的网络" theImage:nil];
                [weakSelf setRootViewAfterPlatFormLogin];
            });
        } progress:nil];
        }
    
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
            loginVC.isLogOut = @"1";
        BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        kWindow.rootViewController = navigation;
        }
}

+ (void)setRootLoginView
{
    MAIN(^{
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    });
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.isLogOut = @"1";
    BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
    kWindow.rootViewController = navigation;
}

    //登录后执行的操作
+ (void)operationAfterLogin
{
    //设置极光推送别名
    NSString *userName = [PersonInfo shareInstance].username;
    NSInteger seqID = [[PersonInfo shareInstance].accountID integerValue];
    
    NSString *comTag = [NSString stringWithFormat:@"C_%@",[PersonInfo shareInstance].comId];
    NSSet *pushSet = [[NSSet alloc] initWithObjects:@"all",comTag, nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [JPUSHService setAlias:userName completion:^(NSInteger iResCode,NSString *iAlias, NSInteger seq)
        {
             DLog(@"极光推送 设置别名iResCode = %ld-------------iAlias=%@,-------------seq=%ld",iResCode,iAlias,seq);
        } seq:seqID];

        [JPUSHService setTags:pushSet completion:^(NSInteger iResCode,NSSet *iTags, NSInteger seq){
            DLog(@"极光推送 设置Tag值 iResCode = %ld-------------iTags=%@,-------------seq=%ld",iResCode,iTags,seq);
        } seq:seqID];
        
        
    });
}


@end
