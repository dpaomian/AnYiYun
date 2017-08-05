//
//  ModifyPasswordCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "ModifyPasswordCell.h"

@implementation ModifyPasswordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftTextLabel];
        [self addSubview:self.pwdTextField];
        [self addSubview:self.bottomLineView];
    }
    return self;
}

#pragma mark - getter

- (UILabel *)leftTextLabel
{
    if (!_leftTextLabel) {
        _leftTextLabel = [[UILabel alloc] init];
        _leftTextLabel.frame = CGRectMake(0, 0, 80, 50);
        _leftTextLabel.font = SYSFONT_(14);
        _leftTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _leftTextLabel;
}
- (UITextField *)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.frame = CGRectMake(CGRectGetMaxX(self.leftTextLabel.frame), 0, self.width - 70, 50);
        _pwdTextField.font = SYSFONT_(14);
        _pwdTextField.secureTextEntry = YES;
        
    }
    return _pwdTextField;
}

-(UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.frame = CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5);
        _bottomLineView.backgroundColor = kAPPTableViewLineColor;
    }
    return _bottomLineView;
}

@end
