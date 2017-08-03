//
//  FirePowerSupplyTabBarRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FirePowerSupplyTabBarRootViewController.h"
#import "FirePowerSupplySafetyMonitoringRootViewController.h"
#import "FirePowerSupplyEquipmentManagementRootViewController.h"
#import "PopViewController.h"

@interface FirePowerSupplyTabBarRootViewController ()

@property (nonatomic, strong) BaseNavigationViewController *popNavVC;

@end

@implementation FirePowerSupplyTabBarRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消防电源";
    
    self.tabBar.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    [self setRightBarItem];
    
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:NSStringFromClass([PopViewController class]) bundle:nil];
    _popNavVC = [[BaseNavigationViewController alloc] initWithRootViewController:popVC];
    _popNavVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _popNavVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self addChildVC:[[FirePowerSupplySafetyMonitoringRootViewController alloc] init] title:@"实时监测" image:@"bottom_btn_1" selectedImage:@"ic_tab_home_blue"];
    [self addChildVC:[[FirePowerSupplyEquipmentManagementRootViewController alloc] init] title:@"设备管理" image:@"bottom_btn_2" selectedImage:@"ic_tab_me_blue"];
}

-(void)setRightBarItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"right_more.png" hightImageName:@"right_more.png" target:self action:@selector(rightBarButtonAction)];
}

//点击弹出框
-(void)rightBarButtonAction
{
    [self.tabBarController presentViewController:_popNavVC animated:NO completion:nil];
}

/**
 *  添加一个子控制器
 *
 *   childVc       子控制器
 *   title         标题
 *   image         图片
 *   selectedImage 选中的图片
 */
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(123, 123, 123)} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kAPPBlueColor } forState:UIControlStateSelected];
    
    [self addChildViewController:childVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end