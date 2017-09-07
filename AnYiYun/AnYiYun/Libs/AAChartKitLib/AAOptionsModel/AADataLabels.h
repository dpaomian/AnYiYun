//
//  AADataLabels.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/6.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AAStyle;
@interface AADataLabels : NSObject
AAPropStatementAndFuncStatement(assign, AADataLabels, BOOL , enabled);
AAPropStatementAndFuncStatement(strong, AADataLabels, AAStyle *, style);
AAPropStatementAndFuncStatement(copy, AADataLabels, NSString *, format);

@end
