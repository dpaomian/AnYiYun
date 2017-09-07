//
//  EquipmentManagementRootViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "YYSegmentedView.h"
/*设备管理 */
#import "MaintenanceRemindersViewController.h"
#import "EquipmentAccountViewController.h"

/*!设备管理*/
@interface EquipmentManagementRootViewController : BaseViewController


/*!低部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *topStateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!维保提醒*/
@property (nonatomic, strong) MaintenanceRemindersViewController *reminderVC;
/*!设备台账 */
@property (nonatomic, strong) EquipmentAccountViewController *accountVC;

@end
