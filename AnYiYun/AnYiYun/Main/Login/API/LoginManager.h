//
//  LoginManager.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : AFNManager

/**获取登录 API*/
+ (void)loginWithAccount:(NSString *)account
                    inVC:(UIViewController *)vc
completionBlockWithSuccess:(requestBlockSuccess)success
                 failure:(requestFailure)failure;


+ (void)operationAfterLogin;

@end
