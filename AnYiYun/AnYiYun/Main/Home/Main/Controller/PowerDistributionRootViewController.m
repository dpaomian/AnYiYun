//
//  PowerDistributionRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "PowerDistributionRootViewController.h"

@interface PowerDistributionRootViewController ()

@end

@implementation PowerDistributionRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"供配电";
        
    __weak PowerDistributionRootViewController *ws = self;
    
    _topStateView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 44.0f)];
    _topStateView.backgroundColor = UIColorFromRGB(0x000000);
    _topStateView.selectedIndex = 0;
    _topStateView.titlesArray = @[@"实时监测",@"告警信息"];
    _topStateView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (ws.bottomStateView.selectedIndex == 0) {
                if (index == 0) {
                    [ws replaceController:ws.currentViewController newController:ws.realtimeVC];
                } else {
                    [ws replaceController:ws.currentViewController newController:ws.informationVC];
                }
            } else {
                if (index == 0) {
                    [ws replaceController:ws.currentViewController newController:ws.reminderVC];
                } else {
                    [ws replaceController:ws.currentViewController newController:ws.accountVC];
                }
            }
        }
    };
    [self.view addSubview:_topStateView];
    
    _bottomStateView = [[YYTabBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -49- NAV_HEIGHT, SCREEN_WIDTH, 49.0f)];
    _bottomStateView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _bottomStateView.selectedIndex = 0;
    _bottomStateView.titlesArray = @[@"安全监控",@"设备管理"];
    _bottomStateView.itemHandle = ^(YYTabBarView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                ws.topStateView.titlesArray = @[@"实时监测",@"告警信息"];
                ws.topStateView.selectedIndex = 0;
                [ws replaceController:ws.currentViewController newController:ws.realtimeVC];
            } else {
                ws.topStateView.titlesArray = @[@"维保提醒",@"设备台账"];
                ws.topStateView.selectedIndex = 0;
                [ws replaceController:ws.currentViewController newController:ws.reminderVC];
            }
        }
    };
    [self.view addSubview:_bottomStateView];
    
    _realtimeVC = [[RealtimeMonitoringViewController alloc] initWithNibName:NSStringFromClass([RealtimeMonitoringViewController class]) bundle:nil];
    [_realtimeVC.view setFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-49.0f-44.0f)];
    _informationVC = [[AlarmInformationViewController alloc] initWithNibName:NSStringFromClass([AlarmInformationViewController class]) bundle:nil];
    
    _reminderVC = [[MaintenanceRemindersViewController alloc] initWithNibName:NSStringFromClass([MaintenanceRemindersViewController class]) bundle:nil];
    _accountVC = [[EquipmentAccountViewController alloc] initWithNibName:NSStringFromClass([EquipmentAccountViewController class]) bundle:nil];
    
    _currentViewController = _realtimeVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    __weak PowerDistributionRootViewController *ws = self;
    nowController.view.frame = CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-49.0f-44.0f);
    [self addChildViewController:nowController];
    [_currentViewController willMoveToParentViewController:nil];
    [self transitionFromViewController:oldController toViewController:nowController duration:1.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
//            [oldController removeFromParentViewController];
            [nowController didMoveToParentViewController:self];
            ws.currentViewController = nowController;
        }else{
            ws.currentViewController = oldController;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
