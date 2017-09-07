//
//  BusinessItemViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/25.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "AllApplicationReusableView.h"
#import "AllApplicationCollectionViewCell.h"

/**
 全部模块入口
 */
@interface BusinessItemViewController : BaseViewController  <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView    *allCollectionView;

@end
