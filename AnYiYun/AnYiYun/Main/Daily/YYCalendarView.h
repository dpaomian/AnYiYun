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
/*!在导航使用日报时记录时间*/
@property (nonatomic, strong) NSDate                            *dailyDate;
/*!在导航使用月报时记录时间*/
@property (nonatomic, strong) NSDate                            *monthDate;
/*!在使用日历时记录时间*/
@property (nonatomic, strong) NSDate                            *calendarDate;

/*!每个月开始几天（上个月）+本月天数+最后几天( 下个月)*/
@property (nonatomic, strong) NSMutableArray                    *allDays;
/*!每个月刚开始几天（上个月）*/
@property (nonatomic, strong) NSMutableArray                    *firstDays;
/*!每个月最后几天（下个月）*/
@property (nonatomic, strong) NSMutableArray                    *lastDays;


/*!上级按钮*/
@property (strong, nonatomic) IBOutlet UIButton *superiorButton;
/*!日期按钮*/
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
/*!下级按钮*/
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
/*!是否是在导航上使用，默认YES*/
@property (assign, nonatomic) BOOL              isNavigation;
/*!日期发生改变时的回调*/
@property (copy, nonatomic) void (^dateChangeHandle)(NSInteger yyYear, NSInteger yyMonth, NSInteger yyDay);

-(void)updateDate:(NSDate*)date;

@end
