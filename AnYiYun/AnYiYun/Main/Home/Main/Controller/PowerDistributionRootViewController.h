//
//  PowerDistributionRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "SecurityMonitoringViewController.h"
#import "EquipmentManagementViewController.h"
#import "YYTabBarView.h"

/*!供配电跟页面*/
@interface PowerDistributionRootViewController : BaseViewController

/*!低部选项卡视图*/
@property (nonatomic, strong) YYTabBarView  *stateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!安全监测*/
@property (nonatomic, strong) SecurityMonitoringViewController *monitoringVC;
/*!设备管理 */
@property (nonatomic, strong) EquipmentManagementViewController *managementVC;
/*!被选中的选项*/
@property (nonatomic, assign) NSInteger   selectedInedex;

@end
