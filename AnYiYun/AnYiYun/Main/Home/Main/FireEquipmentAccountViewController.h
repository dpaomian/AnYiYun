//
//  FireEquipmentAccountViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterCollectionView.h"

/*!设备台账*/
@interface FireEquipmentAccountViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary   *listMutableDic;
@property (strong, nonatomic) FilterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary   *conditionDic;

@end
