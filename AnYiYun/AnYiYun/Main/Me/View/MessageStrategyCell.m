//
//  MessageStrategyCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MessageStrategyCell.h"

@implementation MessageStrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField1.delegate = self;
    _textField2.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _alertImageView.hidden = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] <300) {
        _alertImageView.hidden = NO;
    } else {
        _alertImageView.hidden = YES;
    }
}

@end
