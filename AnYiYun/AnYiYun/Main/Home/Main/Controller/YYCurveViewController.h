//
//  YYCurveViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/6.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYChartsBaseViewController.h"
#import "YYCurveView.h"
#import "YYValueFormatter.h"

@interface YYCurveViewController : YYChartsBaseViewController

@property (nonatomic, strong) NSMutableArray *linesMutableArray;

@property (weak, nonatomic) IBOutlet LineChartView *curveView;
@property (weak, nonatomic) IBOutlet UILabel *yTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *rotateBtn;
@property (weak, nonatomic) IBOutlet UILabel *xTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UILabel *yestodayLab;
@property (weak, nonatomic) IBOutlet UILabel *xTimeLab;

@end
