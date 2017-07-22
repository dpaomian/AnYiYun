//
//  CalendarViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYCalendarView.h"
#import "YYCalendarCollectionViewCell.h"

@interface CalendarViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *calendarCollectionView;

@end
