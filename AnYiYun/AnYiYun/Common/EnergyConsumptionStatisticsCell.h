//
//  EnergyConsumptionStatisticsCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!能耗统计的单元格*/
@interface EnergyConsumptionStatisticsCell : UITableViewCell

/*!总计的标题*/
@property (weak, nonatomic) IBOutlet UILabel *allTitleLab;
/*!总计电量*/
@property (weak, nonatomic) IBOutlet UILabel *allValueLab;
/*!昨日电量*/
@property (weak, nonatomic) IBOutlet UILabel *yesteDayLab;
/*!今日电量*/
@property (weak, nonatomic) IBOutlet UILabel *TodayLab;
/*!上月电量*/
@property (weak, nonatomic) IBOutlet UILabel *lastmonthLab;
/*!当月电量*/
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
/*!标题尾部图标*/
@property (weak, nonatomic) IBOutlet UIImageView *tailImageView;

@end
