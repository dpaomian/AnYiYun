//
//  YYCalendarCollectionViewCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCalendarCollectionViewCell : UICollectionViewCell

/*!日历上特殊标记的图片*/
@property (strong, nonatomic) IBOutlet UIImageView *markImageView;
/*!cell上的文字展示*/
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@end
