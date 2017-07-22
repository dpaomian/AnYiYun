//
//  YYCalendarView.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Category.h"
#import "YYCalendarModel.h"

@interface YYCalendarView : UIView

/*!日历*/
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSDate                            *calendarDate;//日历现在是什么时间
@property (nonatomic, strong) NSMutableArray                    *allDays;//每个月开始几天（上个月）+本月天数+最后几天( 下个月)
@property (nonatomic, strong) NSMutableArray                    *firstDays;//每个月刚开始几天（上个月）
@property (nonatomic, strong) NSMutableArray                    *lastDays;//每个月最后几天（下个月）


/*!上级按钮*/
@property (strong, nonatomic) IBOutlet UIButton *superiorButton;
/*!日期按钮*/
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
/*!下级按钮*/
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

/*!日期发生改变时的回调*/
@property (copy, nonatomic) void (^dateChangeHandle)(NSString *dateString);

-(void)updateDate:(NSDate*)date;

@end
