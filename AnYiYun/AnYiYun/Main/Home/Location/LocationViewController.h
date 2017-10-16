//
//  LocationViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

/**
 定位
 */
@interface LocationViewController : BaseViewController

@property (nonatomic,strong)MessageModel *itemModel;

@property (nonatomic,strong)NSString  *pushType;//区分哪个模块进入的

@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备位置


@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviWalkManager *walkManager;

@end
