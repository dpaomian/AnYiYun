//
//  EquipmentAccountViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterCollectionView.h"

/*!设备台账*/
@interface EquipmentAccountViewController : BaseViewController

@property (strong, nonatomic) FilterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary   *listMutableDic;

@end
