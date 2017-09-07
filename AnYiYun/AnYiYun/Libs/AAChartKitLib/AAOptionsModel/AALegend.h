//
//  AALegend.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/6.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AAItemStyle;
@interface AALegend : NSObject
AAPropStatementAndFuncStatement(assign, AALegend, BOOL, enabled);
AAPropStatementAndFuncStatement(copy, AALegend, NSString *, layout);
AAPropStatementAndFuncStatement(copy, AALegend, NSString *, align);
AAPropStatementAndFuncStatement(copy, AALegend, NSString *, verticalAlign);
AAPropStatementAndFuncStatement(strong, AALegend, NSNumber *, borderWidth);
AAPropStatementAndFuncStatement(strong, AALegend, AAItemStyle *, itemStyle);
 @end
