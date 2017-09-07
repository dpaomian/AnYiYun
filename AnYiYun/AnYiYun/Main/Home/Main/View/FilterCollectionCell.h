//
//  FilterCollectionCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/25.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!筛选框的Item*/
@interface FilterCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIImageView *cornerImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraints;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;

@end
