//
//  UIView+Border.h
//  ToKnow
//
//  Created by zhongyekeji on 15/11/2.
//  Copyright © 2015年 wxs. All rights reserved.
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
