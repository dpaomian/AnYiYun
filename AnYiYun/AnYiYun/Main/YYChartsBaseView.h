//
//  YYChartsBaseView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/6.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface YYChartsBaseView : UIView{

@protected
NSArray *parties;
}

@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) NSArray *options;

@property (nonatomic, assign) BOOL shouldHideData;

- (void)handleOption:(NSString *)key forChartView:(ChartViewBase *)chartView;

- (void)updateChartData;

- (void)setupPieChartView:(PieChartView *)chartView;
- (void)setupRadarChartView:(RadarChartView *)chartView;
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView;

@end
