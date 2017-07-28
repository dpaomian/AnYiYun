//
//  ElectricalFireRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "ElectricalFireRootViewController.h"

@interface ElectricalFireRootViewController ()

@end

@implementation ElectricalFireRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电气火灾";
    
   /* __weak ElectricalFireRootViewController *ws = self;
    
    _stateView = [[YYTabBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -49- NAV_HEIGHT, SCREEN_WIDTH, 49.0f)];
    _stateView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _stateView.selectedIndex = 0;
    _stateView.titlesArray = @[@"安全监控",@"设备管理"];
    _stateView.itemHandle = ^(YYTabBarView *stateView, NSInteger index) {
        stateView.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.3), dispatch_get_main_queue(), ^{
            stateView.userInteractionEnabled = YES;
        });
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                [ws replaceController:ws.currentViewController newController:ws.monitoringVC];
            } else {
                [ws replaceController:ws.currentViewController newController:ws.managementVC];
            }
        }
    };
    [self.view addSubview:_stateView];
    
    _monitoringVC = [[SecurityMonitoringViewController alloc] init];
    [_monitoringVC.view setFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-49.0f)];
    
    _managementVC = [[EquipmentManagementViewController alloc] init];
    
    _currentViewController = _monitoringVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];*/
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    nowController.view.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-49.0f);
    [self addChildViewController:nowController];
    [self transitionFromViewController:oldController toViewController:nowController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [nowController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            _currentViewController = nowController;
        }else{
            _currentViewController = oldController;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
