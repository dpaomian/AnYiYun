//
//  RealtimeMonitoringViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterCollectionView.h"
#import "RealtimeMonitoringListModel.h"
#import "RealtimeMonitoringChildCell.h"
#import "DoubleGraphModel.h"
#import "YYCurveViewController.h"

/*!实时监测*/
@interface RealtimeMonitoringViewController : BaseViewController

@property (strong, nonatomic) FilterCollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray   *listMutableArray;
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;
@property (nonatomic, strong) YYCurveViewController *fullScreenCurveVC;
@property (nonatomic, strong) dispatch_source_t    timer;

@end
