//
//  AASeries.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AASeries.h"
#import "AAMarker.h"
#import "AAAnimation.h"


@implementation AASeries
AAPropSetFuncImplementation(AASeries, NSNumber *, borderRadius);
AAPropSetFuncImplementation(AASeries, AAMarker *, marker);
AAPropSetFuncImplementation(AASeries, NSString *, stacking);
AAPropSetFuncImplementation(AASeries,  AAAnimation*, animation);

@end
