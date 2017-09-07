//
//  FirePowerSupplySafetyMonitoringRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "YYSegmentedView.h"
#import "FirePowerSupplyRealtimeMonitoringViewController.h"
#import "FirePowerSupplyAlarmInformationViewController.h"

/*!安全监测*/
@interface FirePowerSupplySafetyMonitoringRootViewController : BaseViewController


/*!低部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *topStateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!实时监测*/
@property (nonatomic, strong) FirePowerSupplyRealtimeMonitoringViewController *realtimeVC;
/*!告警信息 */
@property (nonatomic, strong) FirePowerSupplyAlarmInformationViewController *informationVC;

@end
