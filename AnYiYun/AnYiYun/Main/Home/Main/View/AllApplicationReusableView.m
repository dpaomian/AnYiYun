//
//  AllApplicationReusableView.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "AllApplicationReusableView.h"

@implementation AllApplicationReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLab];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.88f)];
        lineview.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:lineview];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
