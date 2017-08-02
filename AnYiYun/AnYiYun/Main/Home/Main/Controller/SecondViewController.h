//
//  ViewController.h
//  AAChartKit
//
//  Created by An An on 17/3/13.
//  Copyright © 2017年 An An. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <UIKit/UIKit.h>
#import "AAChartKit.h"
typedef NS_ENUM(NSInteger,SecondeViewControllerChartType) {
    SecondeViewControllerChartTypeColumn =0,
    SecondeViewControllerChartTypeBar,
    SecondeViewControllerChartTypeArea,
    SecondeViewControllerChartTypeAreaspline,
    SecondeViewControllerChartTypeLine,
    SecondeViewControllerChartTypeSpline,
    SecondeViewControllerChartTypeScatter,
};

@interface SecondViewController : UIViewController

@property (nonatomic, assign) NSInteger SecondeViewControllerChartType;
@property (nonatomic, copy  ) NSString  *receivedChartType;
@property (nonatomic, copy) NSString *tTitle;
@property (nonatomic, strong) NSArray *oneArray;//第一条线的数据
@property (nonatomic, strong) NSArray *twoArray;//第二条线的数据
@property (nonatomic, strong) NSArray *timeArray;//
@property (nonatomic, strong) AAChartView *chartView;

- (void)reloadDataUI;


@end

