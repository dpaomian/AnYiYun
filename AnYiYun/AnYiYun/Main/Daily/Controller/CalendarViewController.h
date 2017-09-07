//
//  CalendarViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "YYCalendarView.h"
#import "YYCalendarCollectionViewCell.h"

@interface CalendarViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *calendarCollectionView;
@property (copy, nonatomic) void (^choiceDateHandle)(NSDate *currentDate, NSInteger yyYear, NSInteger yyMonth, NSInteger yyDay);

@end
