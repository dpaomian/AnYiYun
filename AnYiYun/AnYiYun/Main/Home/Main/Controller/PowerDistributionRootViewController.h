//
//  PowerDistributionRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYTabBarView.h"
#import "YYSegmentedView.h"

/*安全监测*/
#import "RealtimeMonitoringViewController.h"
#import "AlarmInformationViewController.h"
/*设备管理 */
#import "MaintenanceRemindersViewController.h"
#import "EquipmentAccountViewController.h"

/*!供配电跟页面*/
@interface PowerDistributionRootViewController : BaseViewController

/*!低部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *topStateView;
/*!低部选项卡视图*/
@property (nonatomic, strong) YYTabBarView  *bottomStateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!实时监测*/
@property (nonatomic, strong) RealtimeMonitoringViewController *realtimeVC;
/*!告警信息 */
@property (nonatomic, strong) AlarmInformationViewController *informationVC;

/*!维保提醒*/
@property (nonatomic, strong) MaintenanceRemindersViewController *reminderVC;
/*!设备台账 */
@property (nonatomic, strong) EquipmentAccountViewController *accountVC;

@end
