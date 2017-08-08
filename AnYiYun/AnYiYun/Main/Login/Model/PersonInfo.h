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
/**登录输入账号*/
@property (nonatomic, copy) NSString *loginTextAccount;
/**密码*/
@property (nonatomic, copy) NSString *password;
/**公司id*/
@property (nonatomic, copy) NSString *comId;
/**公司名称*/
@property (nonatomic, copy) NSString *comName;
/**公司logo*/
@property (nonatomic, copy) NSString *comLogoUrl;
/**姓名*/
@property (nonatomic, copy) NSString *username;

/**是否登录成功过*/
@property (nonatomic) BOOL loginSuccess;

/**是否有未读消息*/
@property (nonatomic) BOOL isUnread;

+ (instancetype)shareInstance;

- (void)initWithDic:(NSDictionary *)dic;

- (void)initWithCacheDic:(NSDictionary *)dic;

@end
