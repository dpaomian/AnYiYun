//
//  LoadDetectionFilterCollectionView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/6.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCollectionCell.h"
#import "SearchCollectionCell.h"
#import "FilterCompanyModel.h"
#import "BuildingModle.h"
#import "SortModel.h"

/*!复核监测筛选条件选择器*/
@interface LoadDetectionFilterCollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/*!配电室的筛选*/
@property (nonatomic, strong) NSMutableArray *roomMutableArray;
/*!楼的筛选*/
@property (nonatomic, strong) NSMutableArray *buildingMutableArray;
/*!楼的筛选*/
@property (nonatomic, strong) NSMutableArray *sortMutableArray;
/*!去分被选中项  默认为  0   1供电室   2楼   3排序   4搜索*/
@property (nonatomic, assign) NSInteger      selectedIndex;
/*!折叠还是隐藏。 YES为折叠*/
@property (nonatomic, assign) BOOL           isFold;

@property (nonatomic, copy) void (^foldHandle)(LoadDetectionFilterCollectionView *myCollectionView, BOOL isFold);

@property (nonatomic, copy) void (^choiceHandle)(LoadDetectionFilterCollectionView *myCollectionView, id modelObject, NSInteger idx);

/*!加载、刷新筛选项的数据*/
- (void)loadItemsAction;
/*!重新初始化筛选框*/
- (void)iteminitialization;

@end
