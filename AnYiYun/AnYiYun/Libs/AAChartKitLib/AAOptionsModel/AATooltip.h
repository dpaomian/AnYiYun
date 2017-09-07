//
//  AATooltip.h
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import <Foundation/Foundation.h>

@interface AATooltip : NSObject
AAPropStatementAndFuncStatement(copy, AATooltip, NSString *, headerFormat);
AAPropStatementAndFuncStatement(copy, AATooltip, NSString *, pointFormat);
AAPropStatementAndFuncStatement(copy, AATooltip, NSString *, footerFormat);
AAPropStatementAndFuncStatement(assign, AATooltip, BOOL, shared);
AAPropStatementAndFuncStatement(assign, AATooltip, BOOL, crosshairs);

//AAPropStatementAndFuncStatement(assign, AATooltip, BOOL, useHTML);
AAPropStatementAndFuncStatement(copy, AATooltip, NSString *, valueSuffix);
@end
