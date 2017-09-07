//
//  AAPie.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/9.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AADataLabels;
@interface AAPie : NSObject
AAPropStatementAndFuncStatement(assign, AAPie, BOOL, allowPointSelect);
AAPropStatementAndFuncStatement(copy, AAPie, NSString *, cursor);
AAPropStatementAndFuncStatement(strong, AAPie, AADataLabels *, dataLabels);
AAPropStatementAndFuncStatement(assign, AAPie, BOOL, showInLegend);
AAPropStatementAndFuncStatement(assign, AAPie, NSNumber *, startAngle);
AAPropStatementAndFuncStatement(assign, AAPie, NSNumber *, endAngle);
AAPropStatementAndFuncStatement(strong, AAPie, NSNumber *, depth);

@end
