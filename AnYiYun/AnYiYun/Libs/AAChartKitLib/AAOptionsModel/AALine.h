//
//  AALine.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/6.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AADataLabels;
@interface AALine : NSObject
AAPropStatementAndFuncStatement(strong, AALine, NSNumber *, lineWidth);//设置折线的宽度
AAPropStatementAndFuncStatement(strong, AALine, AADataLabels *, dataLabels);
//AAPropStatementAndFuncStatement(assign, AALine, BOOL, enableMouseTracking);
@end
