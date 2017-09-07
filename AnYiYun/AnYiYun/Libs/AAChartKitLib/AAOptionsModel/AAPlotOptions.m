//
//  AAPlotOptions.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AAPlotOptions.h"
#import "AAColumn.h"
#import "AALine.h"
#import "AAPie.h"
#import "AABar.h"
#import "AASpline.h"
#import "AAArea.h"
#import "AAAreaspline.h"
#import "AASeries.h"
@implementation AAPlotOptions
AAPropSetFuncImplementation(AAPlotOptions, AAColumn *, column);
AAPropSetFuncImplementation(AAPlotOptions, AALine *, line);
AAPropSetFuncImplementation(AAPlotOptions, AAPie *, pie);
AAPropSetFuncImplementation(AAPlotOptions, AABar *, bar);
AAPropSetFuncImplementation(AAPlotOptions, AASpline *, spline);
AAPropSetFuncImplementation(AAPlotOptions, AASeries *, series);
AAPropSetFuncImplementation(AAPlotOptions, AAArea *, area);
AAPropSetFuncImplementation(AAPlotOptions, AAAreaspline *, areaspline);

@end
