//
//  YYAlarmCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YYAlarmCellButtonTypeDeal,
    YYAlarmCellButtonTypeRepair,
    YYAlarmCellButtonTypeCurve,
    YYAlarmCellButtonTypeLocation
}YYAlarmCellButtonType;

/*!展示告警类列表*/
@interface YYAlarmCell : UITableViewCell

/*!标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
/*!时间标签*/
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
/*!内容标签*/
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
/*!处理按钮*/
@property (weak, nonatomic) IBOutlet UIButton *dealBtn;
/*!报修按钮*/
@property (weak, nonatomic) IBOutlet UIButton *repairBtn;
/*!曲线按钮*/
@property (weak, nonatomic) IBOutlet UIButton *curveBtn;
/*!定位按钮*/
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (nonatomic, copy) void (^btnClickedHandle)(YYAlarmCell *yyCell, YYAlarmCellButtonType clickedType);

@end
