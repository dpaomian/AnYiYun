//
//  UIBarButtonItem+Extension.h
//  xuexin
//
//  Created by 韩亚周 on 16/6/16.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  @brief  返回自定义的导航按钮
 *
 *  @param imageName  普通图片
 *  @param hightImage 选中图片
 *  @param target     target
 *  @param action     方法
 *
 *  @return 自定义的导航按钮
 */
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                        hightImageName:(NSString *)hightImage
                                target:(id)target
                                action:(SEL)action;


/**
 *  导航栏文字 按钮
 *
 *  @param title  按钮标题
 *  @param target target
 *  @param action 方法
 *
 *  @return 自定义的右侧导航按钮
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                                 target:(id)target
                                 action:(SEL)action;


@end
