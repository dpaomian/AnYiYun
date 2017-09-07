//
//  AAColumn.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AAColumn.h"
#import "AADataLabels.h"
@implementation AAColumn
AAPropSetFuncImplementation(AAColumn, NSNumber *, pointPadding);
AAPropSetFuncImplementation(AAColumn, NSNumber *, borderWidth);
AAPropSetFuncImplementation(AAColumn, BOOL , colorByPoint);
AAPropSetFuncImplementation(AAColumn, AADataLabels *, dataLabels);
AAPropSetFuncImplementation(AAColumn, NSString *, stacking);
AAPropSetFuncImplementation(AAColumn, NSNumber *, borderRadius);

@end
