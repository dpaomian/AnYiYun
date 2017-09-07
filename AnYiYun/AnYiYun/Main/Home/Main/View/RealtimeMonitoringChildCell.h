//
//  RealtimeMonitoringChildCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealtimeMonitoringChildCell : UITableViewCell

/*!标题*/
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *lineIconBtn;
/*!后边的内容*/
@property (strong, nonatomic) IBOutlet UIButton *contentBtn;
/*!尾部的小图片*/
@property (strong, nonatomic) IBOutlet UIImageView *tailImageView;

@end
