//
//  LoadDetectionViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LoadDatectionHeaderView.h"
#import "LoadDatectionCell.h"
#import "LoadDetectionFilterCollectionView.h"
#import "LoadDetectionModel.h"
#import "RealtimeMonitoringListModel.h"
#import "DoubleGraphModel.h"
#import <Masonry/Masonry.h>
#import "YYCurveViewController.h"

/*!负荷监测*/
@interface LoadDetectionViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

/*!*/
@property (nonatomic, strong) UITableView *tableView;
/*!*/
@property (nonatomic, strong) NSMutableArray   *listMutableArray;
///*!*/
//@property (nonatomic, strong) NSMutableArray   *curveMutableArray1;
///*!*/
//@property (nonatomic, strong) NSMutableArray   *curveMutableArray2;
/*!*/
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;
@property (nonatomic, strong) dispatch_source_t    timer;

@property (nonatomic, strong) YYCurveView *curveView;
@property (nonatomic, strong) YYCurveViewController *fullScreenCurveVC;
@property (nonatomic, strong) LoadDetectionFilterCollectionView *collectionView;

@end
