//
//  FireSafetyMonitoringRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FireSafetyMonitoringRootViewController.h"

@interface FireSafetyMonitoringRootViewController ()

@end

@implementation FireSafetyMonitoringRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak FireSafetyMonitoringRootViewController *ws = self;
    
    _topStateView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 44.0f)];
    _topStateView.backgroundColor = UIColorFromRGB(0x000000);
    _topStateView.selectedIndex = 0;
    _topStateView.titlesArray = @[@"实时监测",@"告警信息"];
    _topStateView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                [ws replaceController:ws.currentViewController newController:ws.realtimeVC];
            } else {
                [ws replaceController:ws.currentViewController newController:ws.informationVC];
            }
        }
    };
    [self.view addSubview:_topStateView];
    
    _realtimeVC = [[FireRealtimeMonitoringViewController alloc] initWithNibName:NSStringFromClass([FireRealtimeMonitoringViewController class]) bundle:nil];
    [_realtimeVC.view setFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f)];
    _informationVC = [[FireAlarmInformationViewController alloc] initWithNibName:NSStringFromClass([FireAlarmInformationViewController class]) bundle:nil];
    
    _currentViewController = _realtimeVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    __weak FireSafetyMonitoringRootViewController *ws = self;
    nowController.view.frame = CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
    [self addChildViewController:nowController];
    [_currentViewController willMoveToParentViewController:nil];
    [self transitionFromViewController:oldController toViewController:nowController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
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
