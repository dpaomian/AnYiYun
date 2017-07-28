//
//  SafetyMonitoringRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYSegmentedView.h"
#import "RealtimeMonitoringViewController.h"
#import "AlarmInformationViewController.h"

/*!安全监测*/
@interface SafetyMonitoringRootViewController : BaseViewController


/*!低部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *topStateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!实时监测*/
@property (nonatomic, strong) RealtimeMonitoringViewController *realtimeVC;
/*!告警信息 */
@property (nonatomic, strong) AlarmInformationViewController *informationVC;

@end
