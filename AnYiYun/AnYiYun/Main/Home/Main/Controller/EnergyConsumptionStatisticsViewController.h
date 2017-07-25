//
//  EnergyConsumptionStatisticsViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseTableViewController.h"
#import "EnergyConsumptionStatisticsCell.h"

/*!能耗统计*/
@interface EnergyConsumptionStatisticsViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
