//
//  AASeriesElement.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AAMarker;
@interface AASeriesElement : NSObject
AAPropStatementAndFuncStatement(strong, AASeriesElement, NSNumber *, borderRadius);
AAPropStatementAndFuncStatement(copy, AASeriesElement, NSString *, type);
AAPropStatementAndFuncStatement(copy, AASeriesElement, NSString *, name);
AAPropStatementAndFuncStatement(strong, AASeriesElement, NSArray *,data);
AAPropStatementAndFuncStatement(strong, AASeriesElement, AAMarker *, marker);
AAPropStatementAndFuncStatement(copy, AASeriesElement, NSString *, stacking);
@end
