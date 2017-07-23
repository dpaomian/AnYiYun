//
//  MBProgressHUD+YY.h
//  HNRuMi
//
//  Created by 韩亚周 on 16/1/25.
//  Copyright © 2016年 HYZ. All rights reserved.
//

#import "MBProgressHUD.h"

/*!MBProgressHUD扩展*/
@interface MBProgressHUD (YY)

/*!显示成功图片加文字，展示在window的最上层view上*/
+ (void)showSuccess:(NSString *)success;
/*!显示成功文字＋图片，展示在指定的view上*/
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/*!显示失败图片加文字，展示在window的最上层view上*/
+ (void)showError:(NSString *)error;
/*!显示失败图片加文字，展示在指定的view上*/
+ (void)showError:(NSString *)error toView:(UIView *)view;

/*!显示HUD加文字，展示在window的最上层view上*/
+ (MBProgressHUD *)showMessage:(NSString *)message;
/*!显示HUD加文字，展示在指定的view上*/
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/*!隐藏MBProgressHUD*/
+ (void)hideHUD;
/*!隐藏指定的view上MBProgressHUD*/
+ (void)hideHUDForView:(UIView *)view;

@end
