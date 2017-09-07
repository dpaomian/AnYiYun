//
//  AASeries.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>
@class AAMarker,AAAnimation;
@interface AASeries : NSObject
AAPropStatementAndFuncStatement(strong, AASeries, NSNumber *, borderRadius);
AAPropStatementAndFuncStatement(strong, AASeries, AAMarker *, marker);
AAPropStatementAndFuncStatement(copy, AASeries, NSString *, stacking);
AAPropStatementAndFuncStatement(strong, AASeries, AAAnimation *, animation);

@end
