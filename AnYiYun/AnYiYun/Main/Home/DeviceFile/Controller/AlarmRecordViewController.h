//
//  AlarmRecordViewController.h
//  AnYiYun
//
//  Created by wwr on 2017/7/28.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
/**
 告警记录
 */
@interface AlarmRecordViewController : BaseViewController

@property (nonatomic,strong)NSString  *pushType;//区分哪个模块进入的

@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备位置

@end
