//
//  SecurityMonitoringViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "SecurityMonitoringViewController.h"

@interface SecurityMonitoringViewController ()

@end

@implementation SecurityMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    __weak SecurityMonitoringViewController *ws = self;
    
    _stateView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 44.0f)];
    _stateView.backgroundColor = UIColorFromRGB(0x000000);
    _stateView.selectedIndex = 0;
    _stateView.titlesArray = @[@"实时监测",@"告警信息"];
    _stateView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
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
    [self.view addSubview:_stateView];
    
    _realtimeVC = [[RealtimeMonitoringViewController alloc] initWithNibName:NSStringFromClass([RealtimeMonitoringViewController class]) bundle:nil];
    [_realtimeVC.view setFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, SCREEN_HEIGHT-44.0f)];
    
    _informationVC = [[AlarmInformationViewController alloc] initWithNibName:NSStringFromClass([AlarmInformationViewController class]) bundle:nil];
    
    _currentViewController = _realtimeVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    nowController.view.frame = CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-44.0f-49.0f);
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