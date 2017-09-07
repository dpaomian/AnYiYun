//
//  UIView+Border.h
//  ToKnow
//
//  Created by 韩亚周 on 15/11/2.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

/**UIView下边框颜色 宽读*/
- (void)addBottomBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth margin:(CGFloat)margin;

/**UIView左边框颜色 宽读*/
- (void)addLeftBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

/**UIView右边框颜色 宽读*/
- (void)addRightBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

/**UIView上边框颜色 宽读*/
- (void)addTopBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth margin:(CGFloat)margin;


@end
