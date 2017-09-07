//
//  JXLayoutButton.h
//  JXLayoutButtonDemo
//
//  Created by 韩亚周 on 16/9/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JXLayoutButtonStyle) {
    JXLayoutButtonStyleLeftImageRightTitle,
    JXLayoutButtonStyleLeftTitleRightImage,
    JXLayoutButtonStyleUpImageDownTitle,
    JXLayoutButtonStyleUpTitleDownImage
};

/// 重写layoutSubviews的方式实现布局，忽略imageEdgeInsets、titleEdgeInsets和contentEdgeInsets
@interface JXLayoutButton : UIButton

/// 布局方式
@property (nonatomic, assign) JXLayoutButtonStyle layoutStyle;
/// 图片和文字的间距，默认值8
@property (nonatomic, assign) CGFloat midSpacing;
/// 指定图片size
@property (nonatomic, assign) CGSize imageSize;

@end
