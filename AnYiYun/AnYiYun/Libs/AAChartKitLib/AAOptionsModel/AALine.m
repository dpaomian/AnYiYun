//
//  AALine.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/6.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AALine.h"
#import "AADataLabels.h"
@implementation AALine
-(instancetype)init{
    self = [super init];
    if (self ) {
//        self.lineWidth = @5;
        
    }
    return self;
}
AAPropSetFuncImplementation(AALine, NSNumber *, lineWidth);
AAPropSetFuncImplementation(AALine, AADataLabels *, dataLabels);
//AAPropSetFuncImplementation(AALine, BOOL , enableMouseTracking);
@end
