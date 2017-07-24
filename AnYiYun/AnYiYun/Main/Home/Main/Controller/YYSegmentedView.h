//
//  YYSegmentedView.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSegmentedCollectionCell.h"

/*!选项卡*/
@interface YYSegmentedView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray            *titlesArray;
@property (nonatomic, assign) NSInteger          selectedIndex;
@property (nonatomic, copy ) void (^itemHandle) (YYSegmentedView *stateView, NSInteger index);

@end
