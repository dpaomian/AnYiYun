//
//  AATooltip.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/5.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AATooltip.h"

@implementation AATooltip
AAPropSetFuncImplementation(AATooltip, NSString *, headerFormat);
AAPropSetFuncImplementation(AATooltip, NSString *, pointFormat);
AAPropSetFuncImplementation(AATooltip, NSString *, footerFormat);
AAPropSetFuncImplementation(AATooltip, BOOL , shared);
AAPropSetFuncImplementation(AATooltip, BOOL,  crosshairs);
//AAPropSetFuncImplementation(AATooltip, BOOL , useHTML);
AAPropSetFuncImplementation(AATooltip, NSString *, valueSuffix);
@end
