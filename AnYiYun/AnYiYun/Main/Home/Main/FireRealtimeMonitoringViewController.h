//
//  FireRealtimeMonitoringViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterCollectionView.h"
#import "RealtimeMonitoringListModel.h"
#import "RealtimeMonitoringChildCell.h"
#import "DoubleGraphModel.h"
#import "YYCurveViewController.h"

/*!实时监测*/
@interface FireRealtimeMonitoringViewController : BaseViewController

@property (strong, nonatomic) FilterCollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray   *listMutableArray;
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;
@property (nonatomic, strong) YYCurveViewController *fullScreenCurveVC;

@end
