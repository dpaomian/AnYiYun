//
//  MessageTopView.m
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MessageTopView.h"

@implementation MessageTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.alarmButton];
        [self addSubview:self.examButton];
        [self addSubview:self.maintainButton];
        [self addSubview:self.bottomView];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineView.centerX = self.alarmButton.centerX;
}

#pragma mark - getter
- (UIButton *)alarmButton
{
    if(!_alarmButton){
        _alarmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width/3, self.height)];
        [_alarmButton setTitle:@"告警" forState:UIControlStateNormal];
        [_alarmButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
        _alarmButton.titleLabel.font = SYSFONT_(14);
        _alarmButton.tag = 11;
    }
    return _alarmButton;
}

- (UIButton *)examButton
{
    if(!_examButton){
        _examButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.alarmButton.frame), 0, self.width/3, self.height)];
        [_examButton setTitle:@"待检修" forState:UIControlStateNormal];
        [_examButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        _examButton.titleLabel.font = SYSFONT_(14);
        _examButton.tag = 12;
    }
    return _examButton;
}

- (UIButton *)maintainButton
{
    if(!_maintainButton){
        _maintainButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.examButton.frame), 0, self.width/3, self.height)];
        [_maintainButton setTitle:@"待保养" forState:UIControlStateNormal];
        [_maintainButton setTitleColor:kAppTitleBlackColor forState:UIControlStateNormal];
        _maintainButton.titleLabel.font = SYSFONT_(14);
        _maintainButton.tag = 13;
    }
    return _maintainButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width/3, 1)];
        _lineView.backgroundColor = kAPPBlueColor;
    }
    return _lineView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _bottomView.backgroundColor = kAppBackgrondColor;
    }
    return _bottomView;
}

- (void)dealloc
{
    self.alarmButton = nil;
    self.examButton = nil;
    self.maintainButton = nil;
    self.lineView = nil;
}
@end
