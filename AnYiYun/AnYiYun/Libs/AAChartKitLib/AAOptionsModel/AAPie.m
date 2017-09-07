//
//  AAPie.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/9.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AAPie.h"
#import "AADataLabels.h"
@implementation AAPie
AAPropSetFuncImplementation(AAPie, BOOL, allowPointSelect);
AAPropSetFuncImplementation(AAPie, NSString *, cursor);
AAPropSetFuncImplementation(AAPie, AADataLabels *, dataLabels);
AAPropSetFuncImplementation(AAPie, BOOL, showInLegend);
AAPropSetFuncImplementation(AAPie, NSNumber *, startAngle);
AAPropSetFuncImplementation(AAPie, NSNumber *, endAngle);
AAPropSetFuncImplementation(AAPie, NSNumber *, depth);


@end
