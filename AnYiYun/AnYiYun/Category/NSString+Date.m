//
//  NSString+Date.m
//  BaseProject
//
//  Created by 韩亚周 on 16/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)dateExchangeWithTDateFormat:(NSString *)dateFormatStr
{
    NSString *dateStr = dateFormatStr;
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    long long int timeInterval = (llrint)([date timeIntervalSince1970] * 1000);
    return [NSString stringWithFormat:@"%lld", timeInterval];
}

@end
