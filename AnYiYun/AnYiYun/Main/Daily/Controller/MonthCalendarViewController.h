//
//  MonthCalendarViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"

/*!月份选择器*/
@interface MonthCalendarViewController : BaseViewController

@property (copy, nonatomic) void (^choiceMonthHandle)(NSInteger yyYear, NSInteger yyMonth);

@end
