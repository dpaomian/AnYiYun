//
//  ViewController.m
//  AAChartKit
//
//  Created by An An on 17/3/13.
//  Copyright © 2017年 An An. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "SecondViewController.h"

@interface SecondViewController ()<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *chartModel;


@end

@implementation SecondViewController

- (void)buttonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self configThesegmentedControl];
//    [self configTheSwitch];
//    self.chartModel.markerRadius = @0;
    AAChartType chartType = AAChartTypeSpline;
//    self.title = [NSString stringWithFormat:@"%@ chart",chartType];
    [self configTheChartView:chartType];
    
}

- (void)reloadDataUI {
    [self configTheChartView:AAChartTypeSpline];
}

- (void)configTheChartView:(AAChartType)chartType {
    self.chartView = [[AAChartView alloc]init];
    self.chartView.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.chartView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*SCREEN_WIDTH/SCREEN_HEIGHT);
    self.chartView.contentHeight = SCREEN_WIDTH*SCREEN_WIDTH/SCREEN_HEIGHT;

    [self.view addSubview:self.chartView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 40, 33);
    [button setImage:[UIImage imageNamed:@"all_icon_5.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.chartModel = AAObject(AAChartModel)
    .chartTypeSet(chartType)
    .titleSet(self.tTitle)
    .subtitleSet(@"")
    .pointHollowSet(true)
    .categoriesSet(self.timeArray)
//    .zoomTypeSet(@"AAChartZoomTypeXY")
    .yAxisTitleSet(@"负荷（KW）")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"昨天")
                 .dataSet(self.oneArray),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"今天")
                 .dataSet(self.twoArray)
                 ]
               )
    //标示线的设置
//    .yPlotLinesSet(@[AAObject(AAPlotLinesElement)
//                     .colorSet(@"#F05353")//颜色值(16进制)
//                     .dashStyleSet(@"Dash")//样式：Dash,Dot,Solid等,默认Solid
//                     .widthSet(@(1)) //标示线粗细
//                     .valueSet(@(20)) //所在位置
//                     .zIndexSet(@(1)) //层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
//                     .labelSet(@{@"text":@"标示线1",@"x":@(0),@"style":@{@"color":@"#33bdfd"}})//这里其实也可以像AAPlotLinesElement这样定义个对象来赋值（偷点懒直接用了字典，最会终转为js代码，可参考https://www.hcharts.cn/docs/basic-plotLines来写字典）
//                     ,AAObject(AAPlotLinesElement)
//                     .colorSet(@"#33BDFD")
//                     .dashStyleSet(@"Dash")
//                     .widthSet(@(1))
//                     .valueSet(@(40))
//                     .labelSet(@{@"text":@"标示线2",@"x":@(0),@"style":@{@"color":@"#33bdfd"}})
//                     ,AAObject(AAPlotLinesElement)
//                     .colorSet(@"#ADFF2F")
//                     .dashStyleSet(@"Dash")
//                     .widthSet(@(1))
//                     .valueSet(@(60))
//                     .labelSet(@{@"text":@"标示线3",@"x":@(0),@"style":@{@"color":@"#33bdfd"}})
//                     ]
//                   )
//    //Y轴最大值
//    .yMaxSet(@(50))
    // //Y轴最小值
    .yMinSet(@(0))
    // //是否允许Y轴坐标值小数
    .yAllowDecimalsSet(YES)
    // //指定y轴坐标
//    .yTickPositionsSet(@[@(0),@(25),@(50),@(75),@(100)])
    ;
    self.chartModel.markerRadius = @0;
    self.chartModel.crosshairs = NO;
    [self.chartView aa_drawChartWithChartModel:_chartModel];
}

#pragma mark -- AAChartView delegate
-(void)AAChartViewDidFinishLoad {
    NSLog(@"图表视图已完成加载");
}

- (void)customsegmentedControlCellValueBeChanged:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.tag) {
        case 0:
        {
            NSArray *stackingArr = @[AAChartStackingTypeFalse,
                                     AAChartStackingTypeNormal,
                                     AAChartStackingTypePercent];
            self.chartModel.stacking = stackingArr[segmentedControl.selectedSegmentIndex];
        }
            break;
            
        case 1:
        {
            NSArray *symbolArr = @[AAChartSymbolTypeCircle,
                                   AAChartSymbolTypeSquare,
                                   AAChartSymbolTypeDiamond,
                                   AAChartSymbolTypeTriangle,
                                   AAChartSymbolTypeTriangle_down];
            self.chartModel.symbol = symbolArr[segmentedControl.selectedSegmentIndex];
        }
            break;
            
        default:
            break;
    }
    [self refreshTheChartView];
}

- (void)refreshTheChartView {
    [self.chartView aa_refreshChartWithChartModel:self.chartModel];
}

@end
