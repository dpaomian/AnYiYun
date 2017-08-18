//
//  LoadingViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoadingViewController.h"
#import "RootTabBarViewController.h"
#import "LoginManager.h"
#import "DefultLaunchView.h"//启动页

@interface LoadingViewController ()

@property (nonatomic, strong) NSString *account;

@property (nonatomic, strong) NSString *password;

@property (nonatomic,strong)DefultLaunchView *gifDefultView;
@property (nonatomic,strong)UIImageView *defultView;

@end

@implementation LoadingViewController

- (id)initWithCacheAccount:(NSString *)account password:(NSString *)passsword
{
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.hidden = YES;  //隐藏导航栏

        if ([PersonInfo shareInstance].comLaunchUrl.length>0)
        {
            [self.view addSubview:self.defultView];
            
            NSString *picString = [PersonInfo shareInstance].comLaunchUrl;
            
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",PATH_AT_CACHEDIR(kUserLaunchFolder),[picString lastPathComponent]];
            UIImage *dataImg = [UIImage imageWithContentsOfFile:filePath];
            if (!dataImg)
            {
                [_defultView sd_setImageWithURL:[NSURL URLWithString:picString] placeholderImage:nil];
            }
            else
            {
                _defultView.image = dataImg;
            }
        }
        else
        {
            [self.view addSubview:self.gifDefultView];
        }
        
        _account = account;
        _password = passsword;
        
        [LoginManager operationAfterLogin];
        
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


-(void)defultRemoveLaunchView
{
    [_gifDefultView removeFromSuperview];
    _gifDefultView = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RootTabBarViewController *tabVC = [[RootTabBarViewController alloc] init];
    kWindow.rootViewController = tabVC;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Data Request
- (void)dataRequestWithAccount:(NSString *)account password:(NSString *)password
{
    if ([PersonInfo shareInstance].comLaunchUrl.length>0)
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

#pragma mark -定时器

- (DefultLaunchView *)gifDefultView
{
    __weak typeof (self) weakSelf = self;
    
    if (!_gifDefultView) {
        _gifDefultView = [[DefultLaunchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _gifDefultView.backgroundColor = kAPPBlueColor;
        _gifDefultView.aniamtionImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining){
            [weakSelf defultRemoveLaunchView];
        };
    }
    return _gifDefultView;
}

@end
