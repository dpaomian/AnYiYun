//
//  DeviceFileViewController.h
//  AnYiYun
//
//  Created by wwr on 2017/7/28.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "RealtimeMonitoringListModel.h"

/**
 设备档案
 */
@interface DeviceFileViewController : BaseViewController

@property (nonatomic,strong)RealtimeMonitoringListModel *itemModel;
@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备id

@end
