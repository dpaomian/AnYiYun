//
//  AATitle.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//




#import <Foundation/Foundation.h>
@class AAStyle;
@interface AATitle : NSObject
AAPropStatementAndFuncStatement(copy, AATitle, NSString *, text);
AAPropStatementAndFuncStatement(strong, AATitle, AAStyle *, style);

@end
