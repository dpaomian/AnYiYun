//
//  YYCalendarView.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYCalendarView.h"

@interface YYCalendarView ()

@property (nonatomic, strong) YYCalendarModel  *dateModel;

@end

@implementation YYCalendarView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _allDays = [NSMutableArray array];
    _firstDays = [NSMutableArray array];
    _lastDays = [NSMutableArray array];
    _dateModel = [YYCalendarModel shareModel];
    
    __weak YYCalendarView *ws = self;
    /*点击切换上一个月或前一天*/
    [self.superiorButton buttonClickedHandle:^(UIButton *sender) {
        if (ws.dateModel.isDay) {
            [ws changeDate:-1];
            _dateChangeHandle([NSString stringWithFormat:@"%.2d/%.2d",_dateModel.day,_dateModel.month]);
        } else {
            [ws changeDate:-1];
            _dateChangeHandle([NSString stringWithFormat:@"%.2d/%.2d",_dateModel.year,_dateModel.month]);
        }
    }];
    /*点击选择下一天或下个月*/
    [self.nextButton buttonClickedHandle:^(UIButton *sender) {
        if (ws.dateModel.isDay) {
            [ws changeDate:1];
            _dateChangeHandle([NSString stringWithFormat:@"%.2d/%.2d",_dateModel.day,_dateModel.month]);
        } else {
            [ws changeDate:1];
            _dateChangeHandle([NSString stringWithFormat:@"%.2d/%.2d",_dateModel.year,_dateModel.month]);
        }
    }];
}

- (void)changeDate:(NSInteger)changeValue{
    [_allDays removeAllObjects];
    [_firstDays removeAllObjects];
    [_lastDays removeAllObjects];
    [self setCalendarParameters];
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    if (self.dateModel.isDay) {
        components.day = components.day+changeValue;
    } else {
        components.month = components.month + changeValue;
    }
    [self updateDate:[self.calendar dateFromComponents:components]];
}

-(void)updateDate:(NSDate*)date{
    self.calendarDate = date;
    [self allMonthDays];
    [self setCalendarParameters];
}

- (void)allMonthDays{
        //    获取到具体年月日信息
    if(_calendar == nil){
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *components = [_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        //    现在时间
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    _dateModel.day  = components.day;
    _dateModel.month = components.month;
    _dateModel.year = components.year;
    if (_dateModel.year == nowComponents.year && _dateModel.month == nowComponents.month) {
        _dateModel.day  = nowComponents.day;
    }else{}
    
        //    日历从周日开始 周日 周一。。。。。
    components.day = 2;
    NSDate *firstDayOfMonth = [_calendar dateFromComponents:components];
    NSDateComponents *comps = [_calendar components:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    NSInteger weekday = [comps weekday];
    weekday  = weekday - 2;
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger monthLength = days.length;
        //     每个月的头几天
    components.month -=1;
    NSDate *previousMonthDate = [_calendar dateFromComponents:components];
    NSRange previousMonthDays = [c rangeOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitMonth
                                       forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekday;
        //    每个月的天数
    for (int i = 0; i < weekday; i ++) {
        [_allDays addObject:[NSString stringWithFormat:@"%d",maxDate+i+1]];
        [_firstDays addObject:[NSString stringWithFormat:@"%d",maxDate+i+1]];
    }
    
    for (NSInteger i= 0; i<monthLength; i++){
        [_allDays addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
        //     每个月的后几天
    NSInteger remainingDays = (monthLength + weekday) % columns;
    if(remainingDays >0){
        for (NSInteger i = remainingDays; i < columns; i ++) {
            [_allDays addObject:[NSString stringWithFormat:@"%d",(i+1)-remainingDays]];
            [_lastDays addObject:[NSString stringWithFormat:@"%d",(i+1)-remainingDays]];
        }
    }
    _dateModel.allDays  = self.allDays;
    _dateModel.firstDays = self.firstDays;
    _dateModel.lastDays = self.lastDays;
}

-(void)setCalendarParameters{
    if(_calendar == nil){
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        _dateModel.day  = components.day;
        _dateModel.month = components.month;
        _dateModel.year = components.year;
    }
}

@end
