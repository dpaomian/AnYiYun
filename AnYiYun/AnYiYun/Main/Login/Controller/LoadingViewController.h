//
//  LoadingViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
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
