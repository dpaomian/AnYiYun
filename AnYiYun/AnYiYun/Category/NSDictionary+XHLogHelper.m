//
//  NSDictionary+LogHelper.m
//
//  Created by wxs on 16/7/25.
//  Copyright © 2017年 julong. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLogHelper

#import "NSDictionary+XHLogHelper.h"

@implementation NSDictionary (LogHelper)

#if DEBUG
- (NSString *)descriptionWithLocale:(nullable id)locale{

  return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}
#endif
@end
