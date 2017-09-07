//
//  YYTabBarView.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTabBarCollectionCell.h"

/*!底部选项卡 */
@interface YYTabBarView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray            *titlesArray;
@property (nonatomic, assign) NSInteger          selectedIndex;
@property (nonatomic, copy ) void (^itemHandle) (YYTabBarView *stateView, NSInteger index);

@end
