//
//  EnergyManagementViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "LoadDetectionViewController.h"
#import "EnergyConsumptionStatisticsViewController.h"
#import "YYSegmentedView.h"
#import "FilterCollectionView.h"

/*!能源管理*/
@interface EnergyManagementViewController : BaseViewController

/*!顶部选项卡视图*/
@property (nonatomic, strong) YYSegmentedView  *stateView;

/*!临时控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;

/*!负荷监测*/
@property (nonatomic, strong) LoadDetectionViewController *loadDetectionVC;
/*!能耗统计*/
@property (nonatomic, strong) EnergyConsumptionStatisticsViewController *energyConsumptionStatisticsVC;


@end
