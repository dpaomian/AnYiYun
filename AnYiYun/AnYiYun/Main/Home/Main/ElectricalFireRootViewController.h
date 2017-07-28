//
//  ElectricalFireRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
//#import "SecurityMonitoringViewController.h"
//#import "EquipmentManagementViewController.h"
#import "YYTabBarView.h"

/*!*/
@interface ElectricalFireRootViewController : BaseViewController

/*!低部选项卡视图*/
@property (nonatomic, strong) YYTabBarView  *stateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!安全监测*/
//@property (nonatomic, strong) SecurityMonitoringViewController *monitoringVC;
///*!设备管理 */
//@property (nonatomic, strong) EquipmentManagementViewController *managementVC;

@end
