//
//  SecurityMonitoringViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYSegmentedView.h"
#import "RealtimeMonitoringViewController.h"
#import "AlarmInformationViewController.h"

/*!安全监控*/
@interface SecurityMonitoringViewController : BaseViewController

/*!顶部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *stateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!安全监测*/
@property (nonatomic, strong) RealtimeMonitoringViewController *realtimeVC;
/*!设备管理 */
@property (nonatomic, strong) AlarmInformationViewController *informationVC;
/*!被选中的选项*/
@property (nonatomic, assign) NSInteger   selectedInedex;

@end
