//
//  RealtimeMonitoringViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterCollectionView.h"
#import "RealtimeMonitoringListModel.h"

/*!实时监测*/
@interface RealtimeMonitoringViewController : BaseViewController

@property (weak, nonatomic) FilterCollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray   *listMutableArray;

@end