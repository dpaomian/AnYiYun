//
//  UIView+Border.m
//  ToKnow
//
//  Created by 韩亚周 on 15/11/2.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)addTopBorderWithColor:(UIColor *)color borderWidth:(CGFloat) borderWidth margin:(CGFloat)margin
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    if (margin > 0) {
        border.frame = CGRectMake(margin, self.frame.size.height - borderWidth, self.frame.size.width - 2*margin, borderWidth);
    }
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color borderWidth:(CGFloat) borderWidth margin:(CGFloat)margin
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    if (margin > 0) {
        border.frame = CGRectMake(margin, self.frame.size.height - borderWidth, self.frame.size.width - 2*margin, borderWidth);
    }
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color borderWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color borderWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

@end
