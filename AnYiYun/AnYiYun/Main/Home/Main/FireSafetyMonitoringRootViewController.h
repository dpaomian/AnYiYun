//
//  FireSafetyMonitoringRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYSegmentedView.h"
#import "FireRealtimeMonitoringViewController.h"
#import "FireAlarmInformationViewController.h"

/*!安全监测*/
@interface FireSafetyMonitoringRootViewController : BaseViewController


/*!低部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *topStateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!实时监测*/
@property (nonatomic, strong) FireRealtimeMonitoringViewController *realtimeVC;
/*!告警信息 */
@property (nonatomic, strong) FireAlarmInformationViewController *informationVC;

@end
