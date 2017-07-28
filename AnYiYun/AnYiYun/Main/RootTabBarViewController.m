//
//  RootTabBarViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "HomeMainViewController.h"
#import "DailyMainViewController.h"
#import "EquipmentMainViewController.h"
#import "MeMainViewController.h"
#import "UITabBar+badge.h"
#import "DBDaoDataBase.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildVC:[[HomeMainViewController alloc] init] title:@"首页" image:@"bottom_btn_1" selectedImage:@"ic_tab_home_blue"];
     [self addChildVC:[[DailyMainViewController alloc] init] title:@"日报" image:@"bottom_btn_2" selectedImage:@"ic_tab_me_blue"];
     [self addChildVC:[[EquipmentMainViewController alloc] init] title:@"设备说" image:@"bottom_btn_3" selectedImage:@"ic_tab_me_blue"];
    [self addChildVC:[[MeMainViewController alloc] init] title:@"我的" image:@"bottom_btn_4" selectedImage:@"ic_tab_me_blue"];
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
    
    BaseNavigationViewController *navigationVC = [[BaseNavigationViewController alloc] initWithRootViewController:childVC];
    [self addChildViewController:navigationVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MAIN( (^{
        //查询是否有未读消息
        BOOL isUnRead = [[DBDaoDataBase sharedDataBase] isHaveNoReadHistoryMessageWithType:@""];
        
        [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = obj.viewControllers.firstObject;
            if ([vc isKindOfClass:[MeMainViewController class]])
            {
                if (isUnRead==NO)
                {
                    [self.tabBar hideBadgeOnItemIndex:idx+1];
                }
                else
                {
                    [self.tabBar showBadgeOnItemIndex:idx+1];
                }
            }
        }];
    }));
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
