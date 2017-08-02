//
//  FirePowerSupplyAlarmInformationViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYAlarmCell.h"
#import "FireAlarmInformationModel.h"
#import "LocationViewController.h"

/*!告警信息*/
@interface FirePowerSupplyAlarmInformationViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray   *listMutableArray;
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;

@end
