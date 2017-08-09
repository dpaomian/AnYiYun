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

@property (nonatomic,strong)UIImageView *defultView;

@end

@implementation LoadingViewController

- (id)initWithCacheAccount:(NSString *)account password:(NSString *)passsword
{
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.hidden = YES;  //隐藏导航栏
        
        [self.view addSubview:self.defultView];
        
        UIImage *loadingImage = [UIImage imageNamed:@"Default-1242x2208.png"];
        NSString *picString = [PersonInfo shareInstance].comLaunchUrl;
        [_defultView sd_setImageWithURL:[NSURL URLWithString:picString] placeholderImage:loadingImage];
            
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
    [NSThread sleepForTimeInterval:3.0];
    
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


-(UIImageView *)defultView
{
    if (!_defultView) {
        _defultView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    }
    return _defultView;
}

@end
