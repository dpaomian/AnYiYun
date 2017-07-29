//
//  ElectricalFireTabBarRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "ElectricalFireTabBarRootViewController.h"
#import "FireSafetyMonitoringRootViewController.h"
#import "FireEquipmentManagementRootViewController.h"

@interface ElectricalFireTabBarRootViewController ()

@end

@implementation ElectricalFireTabBarRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电气火灾";
    
    [self addChildVC:[[FireSafetyMonitoringRootViewController alloc] init] title:@"实时监测" image:@"bottom_btn_1" selectedImage:@"ic_tab_home_blue"];
    [self addChildVC:[[FireEquipmentManagementRootViewController alloc] init] title:@"设备管理" image:@"bottom_btn_2" selectedImage:@"ic_tab_me_blue"];
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