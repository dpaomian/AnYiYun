//
//  YYCurveView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/6.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYChartsBaseView.h"
#import "DoubleGraphModel.h"

@interface YYCurveView : YYChartsBaseView

@property (nonatomic, strong) NSMutableArray *linesMutableArray;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *yTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *rotate;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UILabel *yestodayLab;
@property (weak, nonatomic) IBOutlet UILabel *xTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
