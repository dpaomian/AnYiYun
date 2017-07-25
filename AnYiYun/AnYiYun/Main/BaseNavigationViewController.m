//
//  BaseNavigationViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.delegate = weakSelf;
}

+ (void)initialize
{
    /** 通过appearance外表，能够一次性地设置整个项目的UIBarButtonItem的样式 */
    UIBarButtonItem *barAppearance = [UIBarButtonItem appearance];
    
        //设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kAPPNavColor;
    textAttrs[NSFontAttributeName] = SYSFONT_(16);
    [barAppearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
        //设置选择状态的文字属性
    NSMutableDictionary *hightTextAttrs = [NSMutableDictionary dictionary];
    hightTextAttrs[NSForegroundColorAttributeName] = kAPPNavColor;
    hightTextAttrs[NSFontAttributeName] = SYSFONT_(16);
    [barAppearance setTitleTextAttributes:hightTextAttrs forState:UIControlStateHighlighted];
    
        //设置不可用状态的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = kAPPNavColor;
    disableTextAttrs[NSFontAttributeName] = SYSFONT_(16);
    [barAppearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /** 修改导航栏的appearance */
    UINavigationBar *naviAppearance = [UINavigationBar appearance];
    [naviAppearance setTintColor:kAPPNavColor];
    
    if(iOSVersion > 8  && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)])
        {
        [[UINavigationBar appearance] setTranslucent:NO];
        }
    [naviAppearance setBackgroundImage:[UIImage imageWithColor:RGB(51, 51, 51) size:CGSizeMake(SCREEN_WIDTH, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    [naviAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:kAPPNavColor, NSFontAttributeName:SYSFONT_(18.5)}];
    [naviAppearance setShadowImage:[[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(SCREEN_WIDTH, 0.5)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


/**
 *  进入下一级界面
 *
 *  @param viewController 将要进入的界面
 *  @param animated       是否开启动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"main_back_white" hightImageName:@"main_back_white" target:self action:@selector(backAction)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backAction
{
    [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
        // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
