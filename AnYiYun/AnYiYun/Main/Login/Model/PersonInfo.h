//
//  PersonInfo.h
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfo : NSObject

/**帐号 唯一值*/
@property (nonatomic, copy) NSString *accountID;
/**密码*/
@property (nonatomic, copy) NSString *password;
/**姓名*/
@property (nonatomic, copy) NSString *username;

/**是否登录成功过*/
@property (nonatomic) BOOL loginSuccess;


+ (instancetype)shareInstance;

- (void)initWithDic:(NSDictionary *)dic;

- (void)initWithCacheDic:(NSDictionary *)dic;

@end
