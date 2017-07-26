//
//  LoadDatectionCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

/*负荷监测单元格*/
@interface LoadDatectionCell : UITableViewCell

/*!标题*/
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
/*!后边的内容*/
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
/*!尾部的小图片*/
@property (strong, nonatomic) IBOutlet UIImageView *tailImageView;

@end
