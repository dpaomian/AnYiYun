//
//  LoadingViewController.h
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  loading页面，缓存下自动登录
 */
@interface LoadingViewController : BaseViewController

/**
 *  自动登录
 *
 *  @param account   缓存帐号
 *  @param passsword 缓存密码
 *
 */
- (id)initWithCacheAccount:(NSString *)account password:(NSString *)passsword;

@end
