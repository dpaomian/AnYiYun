//
//  EquipmentManagementViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYSegmentedView.h"
#import "MaintenanceRemindersViewController.h"
#import "EquipmentAccountViewController.h"

/*!设备管理*/
@interface EquipmentManagementViewController : BaseViewController

/*!顶部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *stateView;
/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!安全监测*/
@property (nonatomic, strong) MaintenanceRemindersViewController *reminderVC;
/*!设备管理 */
@property (nonatomic, strong) EquipmentAccountViewController *accountVC;
/*!被选中的选项*/
@property (nonatomic, assign) NSInteger   selectedInedex;

@end
