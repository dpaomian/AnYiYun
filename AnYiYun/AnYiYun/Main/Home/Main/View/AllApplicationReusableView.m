//
//  AllApplicationReusableView.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
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
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
