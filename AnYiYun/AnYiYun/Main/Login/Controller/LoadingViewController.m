//
//  LoadingViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoadingViewController.h"
#import "RootTabBarViewController.h"

@interface LoadingViewController ()

@property (nonatomic, strong) NSString *account;

@property (nonatomic, strong) NSString *password;

@end

@implementation LoadingViewController

- (id)initWithCacheAccount:(NSString *)account password:(NSString *)passsword
{
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.hidden = YES;  //隐藏导航栏
        UIImage *loadingImage;
        if (IS_IPHONE_4)
            {
            loadingImage = [UIImage imageNamed:@"splash_default"];
            }
        else
            {
            loadingImage = [UIImage imageNamed:@"splash_default_568h"];
            }
        self.view.layer.contents = (id)loadingImage.CGImage;
        _account = account;
        _password = passsword;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;  //隐藏导航栏
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self dataRequestWithAccount:_account password:_password];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;  //隐藏导航栏
    
}

#pragma mark - Data Request
- (void)dataRequestWithAccount:(NSString *)account password:(NSString *)password
{
        //登录流程
//    [LoginManager getIPWithAccount:account inVC:self completionBlockWithSuccess:^() {
//        MAIN(^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            RootTabBarViewController *tabVC = [[RootTabBarViewController alloc] init];
            kWindow.rootViewController = tabVC;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//        
//    } failure:nil];
}

#pragma mark - getter
- (void)dealloc
{
    self.view = nil;
}


@end
