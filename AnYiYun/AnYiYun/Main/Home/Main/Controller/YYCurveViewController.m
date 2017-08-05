//
//  YYCurveViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/6.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYCurveViewController.h"

@interface YYCurveViewController ()

@end

@implementation YYCurveViewController

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO]; //设置隐藏
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __weak YYCurveViewController *ws = self;
        self.view.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);
        _yTitleLab.transform = CGAffineTransformMakeRotation(270 *M_PI / 180.0);
        
        [_rotateBtn buttonClickedHandle:^(UIButton *sender) {
            [ws.navigationController popViewControllerAnimated:NO];
        }];
        _curveView.chartDescription.enabled = NO;
        
        _curveView.dragEnabled = YES;
        [_curveView setScaleEnabled:YES];
        _curveView.pinchZoomEnabled = YES;
        _curveView.drawGridBackgroundEnabled = NO;
        
        _curveView.legend.form = ChartLegendFormLine;
        
        ChartYAxis *leftAxis = _curveView.leftAxis;
        leftAxis.labelTextColor = [UIColor lightGrayColor];
        [leftAxis removeAllLimitLines];
        leftAxis.axisMinimum = 0.0;
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.drawLimitLinesBehindDataEnabled = YES;
        
        _curveView.rightAxis.enabled = NO;
        
        // 设置X轴
        ChartXAxis *xAxis = _curveView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelTextColor = [UIColor lightGrayColor];
        xAxis.labelFont = [UIFont systemFontOfSize:11.f];
        xAxis.axisMinValue = 0.0;
        xAxis.granularity = 1.0;
        xAxis.drawAxisLineEnabled = YES;    //是否画x轴线
        xAxis.drawGridLinesEnabled = NO;   //是否画网格
        
        _curveView.legend.form = ChartLegendFormLine;
        
        [_curveView animateWithXAxisDuration:2.5];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setLinesMutableArray:(NSMutableArray *)linesMutableArray {
    _linesMutableArray =linesMutableArray;
    
    __block NSInteger count = 0;
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
    }];
    [self setDataCount:[linesMutableArray count] range:range];
    
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
            [currentMutableArray addObject:[[ChartDataEntry alloc] initWithX:[currentmodel.time floatValue] y:[currentmodel.value doubleValue]]];
        }];
        if (idx == 0) {
            [greenLineValue addObjectsFromArray:currentMutableArray];
        } else {
            [blueLineValue addObjectsFromArray:currentMutableArray];
        }
    }];
    
    
    LineChartDataSet *blueSet = nil;
    LineChartDataSet *greenSet = nil;
    if (_curveView.data.dataSetCount > 0)
    {
        blueSet = (LineChartDataSet *)_curveView.data.dataSets[0];
        blueSet.values = blueLineValue;
        greenSet = (LineChartDataSet *)_curveView.data.dataSets[1];
        greenSet.values = greenLineValue;
        [_curveView.data notifyDataChanged];
        [_curveView notifyDataSetChanged];
    }
    else
    {
        blueSet = [[LineChartDataSet alloc] initWithValues:blueLineValue label:@"昨天"];
        blueSet.drawIconsEnabled = NO;
        blueSet.highlightEnabled = NO;//不显示十字线
        blueSet.axisDependency = AxisDependencyLeft;
        blueSet.mode = LineChartModeHorizontalBezier;
        [blueSet setColor:UIColorFromRGB(0x5987F8)];
        blueSet.lineWidth = 2.0;
        blueSet.drawCircleHoleEnabled = NO;
        [blueSet setCircleColor:UIColorFromRGB(0x5987F8)];
        blueSet.fillAlpha = 65/255.0;
        blueSet.fillColor = UIColorFromRGB(0x5987F8);
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
        
        _curveView.data = [[LineChartData alloc] initWithDataSets:dataSets];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
