//
//  FirePowerSupplyMaintenanceRemindersViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "RealtimeMonitoringListModel.h"
#import "FireMaintenanceRemindersModel.h"

/*!维保提醒*/
@interface FirePowerSupplyMaintenanceRemindersViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray   *listMutableArray;
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;

@end
