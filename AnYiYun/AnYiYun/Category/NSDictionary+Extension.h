//
//  NSDictionary+Extension.h
//  xuexin
//
//  Created by 韩亚周 on 16/6/13.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

- (NSString *)jsonString;

//- (NSDictionary *)nullDic;

//将字典拼接为get参数请求格式
//即 {"username":"xxx","password":"123456"} 转换为 username=xxx&password=123456
- (NSString *)serializeToUrlString;

@end
