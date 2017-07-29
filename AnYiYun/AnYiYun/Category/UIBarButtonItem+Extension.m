//
//  UIBarButtonItem+Extension.m
//  xuexin
//
//  Created by wxs on 16/6/16.
//  Copyright © 2016年 julong. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

//图片按钮
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                        hightImageName:(NSString *)hightImage
                                target:(id)target
                                action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    
    //监听按钮事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置按钮的尺寸是当前图片的尺寸
    button.size = button.currentBackgroundImage.size;
    
    //返回自定义的导航按钮
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//文字按钮
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                                 target:(id)target
                                 action:(SEL)action
{
    UIFont *font = SYSFONT_(16);

    NSDictionary *attributesDic = @{NSFontAttributeName:font};
    CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, size.width, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    //监听按钮事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //返回自定义的导航按钮
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
