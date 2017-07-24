//
//  YYSegmentedCollectionCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!选项卡的选项*/
@interface YYSegmentedCollectionCell : UICollectionViewCell

/*!选项卡的标题*/
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
/*!底部的线*/
@property (strong, nonatomic) IBOutlet UIButton *lineButton;

@end
