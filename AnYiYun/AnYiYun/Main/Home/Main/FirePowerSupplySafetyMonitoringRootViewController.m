//
//  FirePowerSupplySafetyMonitoringRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FirePowerSupplySafetyMonitoringRootViewController.h"

@interface FirePowerSupplySafetyMonitoringRootViewController ()

@end

@implementation FirePowerSupplySafetyMonitoringRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak FirePowerSupplySafetyMonitoringRootViewController *ws = self;
    
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
    
    _realtimeVC = [[FirePowerSupplyRealtimeMonitoringViewController alloc] initWithNibName:NSStringFromClass([FirePowerSupplyRealtimeMonitoringViewController class]) bundle:nil];
    [_realtimeVC.view setFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f)];
    _informationVC = [[FirePowerSupplyAlarmInformationViewController alloc] initWithNibName:NSStringFromClass([FirePowerSupplyAlarmInformationViewController class]) bundle:nil];
    
    _currentViewController = _realtimeVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (_topStateView.selectedIndex == 1) {
            return;
        }
        _topStateView.selectedIndex = 1;
        [self replaceController:self.currentViewController newController:self.informationVC];
        _realtimeVC.view.frame = CGRectMake(0, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        _informationVC.view.frame = CGRectMake(SCREEN_WIDTH,44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        [UIView beginAnimations:@"animationID"context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        _realtimeVC.view.frame = CGRectMake(-SCREEN_WIDTH, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        _informationVC.view.frame = CGRectMake(0, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        [UIView commitAnimations];
    } else {
        if (_topStateView.selectedIndex == 0) {
            return;
        }
        _topStateView.selectedIndex = 0;
        [self replaceController:self.currentViewController newController:self.realtimeVC];
        _realtimeVC.view.frame = CGRectMake(-SCREEN_WIDTH, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        _informationVC.view.frame = CGRectMake(0,44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        [UIView beginAnimations:@"animationID"context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        _realtimeVC.view.frame = CGRectMake(0, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        _informationVC.view.frame = CGRectMake(SCREEN_WIDTH, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
        [UIView commitAnimations];
    }
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    __weak FirePowerSupplySafetyMonitoringRootViewController *ws = self;
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
