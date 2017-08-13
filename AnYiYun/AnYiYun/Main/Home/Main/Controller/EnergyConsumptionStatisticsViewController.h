//
//  EnergyConsumptionStatisticsViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseTableViewController.h"
#import "EnergyConsumptionStatisticsCell.h"
#import "EnergyConsumptionStatisticsModel.h"

/*!能耗统计*/
@interface EnergyConsumptionStatisticsViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/*!*/
@property (nonatomic, strong) NSMutableArray   *listMutableArray;
/*!*/
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;
@property (nonatomic, strong) dispatch_source_t    timer;

@end
