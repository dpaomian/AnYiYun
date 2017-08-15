//
//  YYValueFormatter.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/16.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYValueFormatter.h"

@implementation YYValueFormatter

-(id)init{
    if (self = [super init]) {
        
    }
    return self;}
-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSString * testNumber = [NSString stringWithFormat:@"%f",value];
    return [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
}
@end
