//
//  FireEquipmentManagementRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FireEquipmentManagementRootViewController.h"

@interface FireEquipmentManagementRootViewController ()

@end

@implementation FireEquipmentManagementRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak FireEquipmentManagementRootViewController *ws = self;
    
    _topStateView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 44.0f)];
    _topStateView.backgroundColor = UIColorFromRGB(0x000000);
    _topStateView.selectedIndex = 0;
    _topStateView.titlesArray = @[@"维保提醒",@"设备台帐"];
    _topStateView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                [ws replaceController:ws.currentViewController newController:ws.reminderVC];
            } else {
                [ws replaceController:ws.currentViewController newController:ws.accountVC];
            }
        }
    };
    [self.view addSubview:_topStateView];
    
    _reminderVC = [[FireMaintenanceRemindersViewController alloc] initWithNibName:NSStringFromClass([FireMaintenanceRemindersViewController class]) bundle:nil];
    [_reminderVC.view setFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f)];
    _accountVC = [[FireEquipmentAccountViewController alloc] initWithNibName:NSStringFromClass([FireEquipmentAccountViewController class]) bundle:nil];
    
    _currentViewController = _reminderVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];
    
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    __weak FireEquipmentManagementRootViewController *ws = self;
    nowController.view.frame = CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
    [self addChildViewController:nowController];
    [_currentViewController willMoveToParentViewController:nil];
    [self transitionFromViewController:oldController toViewController:nowController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        [nowController didMoveToParentViewController:self];
        ws.currentViewController = nowController;
        /*if (finished) {
            [oldController removeFromParentViewController];
            [nowController didMoveToParentViewController:self];
            ws.currentViewController = nowController;
        }else{
            ws.currentViewController = oldController;
        }*/
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
