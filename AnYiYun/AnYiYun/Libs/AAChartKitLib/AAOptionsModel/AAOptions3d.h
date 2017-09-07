//
//  AAOptions3d.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/17.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>

@interface AAOptions3d : NSObject
AAPropStatementAndFuncStatement(assign, AAOptions3d, BOOL, enabled);
AAPropStatementAndFuncStatement(strong, AAOptions3d, NSNumber *, alpha);
AAPropStatementAndFuncStatement(strong, AAOptions3d, NSNumber *, beta);
@end
