//
//  DeviceFileViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "RealtimeMonitoringListModel.h"

/**
 设备档案
 */
@interface DeviceFileViewController : BaseViewController

/** 默认进入告警设备档案页，请求中间默认initApp 巡检模块进入传值等于devicePatrol*/
@property (nonatomic,strong)NSString  *pushType;//区分哪个模块进入的

@property (nonatomic,strong)RealtimeMonitoringListModel *itemModel;

@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备位置

@end
