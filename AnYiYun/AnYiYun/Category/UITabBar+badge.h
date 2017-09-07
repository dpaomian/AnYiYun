//
//  UITabBar+badge.h
//  BaseProject
//
//  Created by 韩亚周 on 16/10/9.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(NSInteger)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index; //隐藏小红点

@end
