//
//  Subtitle.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AAStyle;
@interface AASubtitle : NSObject
AAPropStatementAndFuncStatement(copy, AASubtitle, NSString *, text);
AAPropStatementAndFuncStatement(copy, AASubtitle, NSString *, align);
AAPropStatementAndFuncStatement(strong, AASubtitle, AAStyle *, style);
@end
