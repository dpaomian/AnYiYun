//
//  NSDictionary+Extension.h
//  xuexin
//
//  Created by wxs on 16/6/13.
//  Copyright © 2016年 julong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

- (NSString *)jsonString;

//- (NSDictionary *)nullDic;

//将字典拼接为get参数请求格式
//即 {"username":"xxx","password":"123456"} 转换为 username=xxx&password=123456
- (NSString *)serializeToUrlString;

@end
