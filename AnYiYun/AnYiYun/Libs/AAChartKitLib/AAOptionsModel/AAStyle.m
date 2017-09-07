//
//  AAStyle.m
//  AAChartKit
//
//  Created by 韩亚周 on 17/1/6.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code
//

#import "AAStyle.h"
//Styles for the label. 默认是：{"color": "contrast", "fontSize": "11px", "fontWeight": "bold", "textOutline": "1px 1px contrast" }.

@implementation AAStyle
-(instancetype)init{
    self = [super init];
    if (self) {
        self.color = @"#ffffff";
        self.fontSize = @"11px";
        self.fontWeight = @"bold";
        self.textOutline = @"1px 1px contrast";
    }
    return self;
}
AAPropSetFuncImplementation(AAStyle, NSString *, color);
AAPropSetFuncImplementation(AAStyle, NSString *, fontSize);
AAPropSetFuncImplementation(AAStyle, NSString *, fontWeight);
AAPropSetFuncImplementation(AAStyle, NSString *, textOutline);
@end
