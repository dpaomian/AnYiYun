//
//  YYCalendarModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*日报上导航日期处理的model*/
@interface YYCalendarModel : NSObject

/*!日/月去分，YES日、NO月*/
@property (nonatomic, assign) BOOL                  isDay;

/*!在导航上使用  年*/
@property (nonatomic, assign) NSInteger             navigationYear;
/*!在导航上使用  月*/
@property (nonatomic, assign) NSInteger             navigationMonth;
/*!在导航上使用  日*/
@property (nonatomic, assign) NSInteger             navigationDay;

/*!年*/
@property (nonatomic, assign) NSInteger             year;
/*!月*/
@property (nonatomic, assign) NSInteger             month;
/*!日*/
@property (nonatomic, assign) NSInteger             day;
/*!每个月开始几天（上个月）+本月天数+最后几天( 下个月)*/
@property (nonatomic, strong) NSArray               *allDays;
/*!每个月刚开始几天（上个月）*/
@property (nonatomic, strong) NSArray               *firstDays;
/*!每个月最后几天（下个月）*/
@property (nonatomic, strong) NSArray               *lastDays;


+ (instancetype)shareModel;

@end
