//
//  EquipmentManagementRootViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "EquipmentManagementRootViewController.h"

@interface EquipmentManagementRootViewController ()

@end

@implementation EquipmentManagementRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak EquipmentManagementRootViewController *ws = self;
    
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
    
    _reminderVC = [[MaintenanceRemindersViewController alloc] initWithNibName:NSStringFromClass([MaintenanceRemindersViewController class]) bundle:nil];
    [_reminderVC.view setFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f)];
    _accountVC = [[EquipmentAccountViewController alloc] initWithNibName:NSStringFromClass([EquipmentAccountViewController class]) bundle:nil];
    
    _currentViewController = _reminderVC;
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
        [self replaceController:self.currentViewController newController:self.accountVC];
    } else {
        if (_topStateView.selectedIndex == 0) {
            return;
        }
        _topStateView.selectedIndex = 0;
        [self replaceController:self.currentViewController newController:self.reminderVC];
    }
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    __weak EquipmentManagementRootViewController *ws = self;
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
