//
//  NSDictionary+Extension.m
//  xuexin
//
//  Created by 韩亚周 on 16/6/13.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSString *)jsonString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:nil];
    return data ? [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding] : nil;
}
- (NSString *)serializeToUrlString
{
    NSString *result = @"";
    if (self == nil || self.count == 0)
    {
        return result;
    }
    for (id key in self)
    {
        result = [NSString stringWithFormat:@"%@%@%@%@%@",result,key,@"=",self[key],@"&"];
    }
    if (result.length > 0)
    {
        result = [result substringToIndex:result.length - 1];
    }
    return result;
}

@end
