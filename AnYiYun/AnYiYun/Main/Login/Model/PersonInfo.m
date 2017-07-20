//
//  PersonInfo.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "PersonInfo.h"

static PersonInfo *instance = nil;

@implementation PersonInfo

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return instance;
}

- (void)initWithDic:(NSDictionary *)dic
{
    NSDictionary *dictionary = [BaseHelper filterNullObj:dic];
    _username = [BaseHelper filterNullObj:dictionary[@"username"]];
    _accountID = [BaseHelper filterNullObj:dictionary[@"usercode"]];
    _loginSuccess = [dictionary[@"loginSuccess"] boolValue];
}

- (void)initWithCacheDic:(NSDictionary *)dic
{
    NSDictionary *dictionary = [BaseHelper filterNullObj:dic];
    _username = dictionary[@"username"];
    _accountID = dictionary[@"accountID"];
    _password = dictionary[@"password"];
    _loginSuccess = [dictionary[@"loginSuccess"] boolValue];
    
}

@end
