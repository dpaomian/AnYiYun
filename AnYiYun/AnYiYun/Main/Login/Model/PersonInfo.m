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
    _accountID = [BaseHelper filterNullObj:dictionary[@"id"]];
    _comId = [BaseHelper filterNullObj:dictionary[@"comId"]];
}

- (void)initWithCacheDic:(NSDictionary *)dic
{
    NSDictionary *dictionary = [BaseHelper filterNullObj:dic];
    _loginTextAccount = dictionary[@"loginTextAccount"];
    _accountID = dictionary[@"accountID"];
    _password = dictionary[@"password"];
    _username = dictionary[@"username"];
    _comId = dictionary[@"comId"];
    _comName = dictionary[@"comName"];
    _comLogoUrl = dictionary[@"comLogoUrl"];
    _loginSuccess = [dictionary[@"loginSuccess"] boolValue];
    _isUnread = [dictionary[@"isUnread"] boolValue];
    
}

@end
