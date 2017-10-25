//
//  RealtimeMonitoringChildSwitchCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealtimeMonitoringChildSwitchCell : UITableViewCell

/*!标题*/
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIButton *lineIconBtn;
/*!后边的内容*/
@property (strong, nonatomic) IBOutlet UISwitch *yySwitch;
/*!尾部的小图片*/
@property (strong, nonatomic) IBOutlet UIImageView *tailImageView;

@end
