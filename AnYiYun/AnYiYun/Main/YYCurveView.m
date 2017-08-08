//
//  YYCurveView.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/6.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYCurveView.h"

@implementation YYCurveView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
    self.layer.borderWidth = 0.88f;
    
    _yTitleLab.transform = CGAffineTransformMakeRotation(270 *M_PI / 180.0);
    
    _chartView.chartDescription.enabled = NO;
    _chartView.userInteractionEnabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelTextColor = [UIColor lightGrayColor];
    [leftAxis removeAllLimitLines];
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    // 设置X轴
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelTextColor = [UIColor lightGrayColor];
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.axisMinValue = 0.5;
    xAxis.granularity = 1.0;
    xAxis.drawAxisLineEnabled = YES;    //是否画x轴线
    xAxis.drawGridLinesEnabled = NO;   //是否画网格
    
    _chartView.legend.form = ChartLegendFormLine;
    
    [_chartView animateWithXAxisDuration:2.5];
}

- (void)setLinesMutableArray:(NSMutableArray *)linesMutableArray {
    _linesMutableArray = linesMutableArray;
    
   /* __block NSInteger count = 0;
    __block double range = 0;
    [linesMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *currentArray = [NSMutableArray arrayWithArray:obj];
        if (count > [currentArray count]) {
            
        } else {
            count = [currentArray count];
        }
        [currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DoubleGraphModel *currentmodel = obj;
            if (range > [currentmodel.value doubleValue]) {
                
            } else {
                range = [currentmodel.value doubleValue];
            }
        }];
    }];*/
    [self setDataCount:20 range:20];
}

- (void)setDataCount:(NSInteger)count range:(double)range {
    NSMutableArray *blueLineValue = [[NSMutableArray alloc] init];
    NSMutableArray *greenLineValue = [[NSMutableArray alloc] init];
    
    /*第一层遍历，遍历出有几条线*/
    [_linesMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * objMutableArray = [NSMutableArray arrayWithArray:obj];
        NSMutableArray *currentMutableArray = [NSMutableArray array];
        [objMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DoubleGraphModel *currentmodel = obj;
            [currentMutableArray addObject:[[ChartDataEntry alloc] initWithX:[currentmodel.time doubleValue] y:[currentmodel.value doubleValue]]];
        }];
        if (idx == 0) {
            [greenLineValue addObjectsFromArray:currentMutableArray];
        } else {
            [blueLineValue addObjectsFromArray:currentMutableArray];
        }
    }];
    
    
    LineChartDataSet *blueSet = nil;
    LineChartDataSet *greenSet = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        blueSet = (LineChartDataSet *)_chartView.data.dataSets[0];
        blueSet.values = blueLineValue;
        greenSet = (LineChartDataSet *)_chartView.data.dataSets[1];
        greenSet.values = greenLineValue;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        blueSet = [[LineChartDataSet alloc] initWithValues:blueLineValue label:@"昨天"];
        blueSet.drawIconsEnabled = NO;
        blueSet.highlightEnabled = NO;//不显示十字线
        blueSet.axisDependency = AxisDependencyLeft;
        blueSet.mode = LineChartModeHorizontalBezier;
        [blueSet setColor:UIColorFromRGB(0x94B0EF)];
        blueSet.lineWidth = 2.0;
        blueSet.drawCircleHoleEnabled = NO;
        [blueSet setCircleColor:UIColorFromRGB(0x94B0EF)];
        blueSet.fillAlpha = 65/255.0;
        blueSet.fillColor = UIColorFromRGB(0x94B0EF);
        blueSet.circleRadius = 0.0;
        blueSet.drawValuesEnabled = NO;
        
        
        greenSet = [[LineChartDataSet alloc] initWithValues:greenLineValue label:@"今天"];
        greenSet.drawIconsEnabled = NO;
        greenSet.highlightEnabled = NO;//不显示十字线
        greenSet.axisDependency = AxisDependencyLeft;
        greenSet.mode = LineChartModeHorizontalBezier;
        [greenSet setColor:[UIColor greenColor]];
        greenSet.lineWidth = 2.0;
        greenSet.drawValuesEnabled = NO;
        greenSet.drawCircleHoleEnabled = NO;
        [greenSet setCircleColor:[UIColor greenColor]];
        greenSet.fillAlpha = 65/255.0;
        greenSet.fillColor = [UIColor greenColor];
        if ([greenLineValue count] < 4) {
            greenSet.circleRadius = 3.0;
            greenSet.drawValuesEnabled = YES;
        } else {
            greenSet.circleRadius = 0.0;
            greenSet.drawValuesEnabled = NO;
        }
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObjectsFromArray:@[blueSet,greenSet]];
        
        _chartView.data = [[LineChartData alloc] initWithDataSets:dataSets];
    }
}

@end
