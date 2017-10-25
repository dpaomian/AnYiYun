//
//  YYPswCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYPswCell.h"

@implementation YYPswCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
    
    _textField.layer.borderColor = UIColorFromRGB(0xDBDBDB).CGColor;
    _textField.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *) trimming:(NSString *)s {
    
    return [s stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark -
#pragma mark UITextFieldDelegate -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self trimming:[textField.text stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]].length > 0) {
        return NO;
    }else{
        NSString *textFieldString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if ([textFieldString length] > 6) {
            if ([string isEqualToString:@""]) {
                [self blackPoint:textFieldString];
                return YES;
            } else {
                return NO;
            }
        } else {
            if ([string isEqualToString:@""]) {
                if (textFieldString.length == 0) {
                    [self blackPoint:@""];
                    return NO;
                } else {
                    textFieldString = [textFieldString substringToIndex:[textFieldString length]-1];
                }
            } else {
                
            }
            [self blackPoint:textFieldString];
            return YES;
        }
    }
}

- (void)blackPoint:(NSString *)textFieldString {
    if ([textFieldString length] == 6) {
        _no1.hidden = NO;
        _no2.hidden = NO;
        _no3.hidden = NO;
        _no4.hidden = NO;
        _no5.hidden = NO;
        _no6.hidden = NO;
        if (_inputOver) {
            _inputOver(self ,textFieldString);
        }
    } else if ([textFieldString length] == 5) {
        _no1.hidden = NO;
        _no2.hidden = NO;
        _no3.hidden = NO;
        _no4.hidden = NO;
        _no5.hidden = NO;
        _no6.hidden = YES;
    } else if ([textFieldString length] == 4) {
        _no1.hidden = NO;
        _no2.hidden = NO;
        _no3.hidden = NO;
        _no4.hidden = NO;
        _no5.hidden = YES;
        _no6.hidden = YES;
    } else if ([textFieldString length] == 3) {
        _no1.hidden = NO;
        _no2.hidden = NO;
        _no3.hidden = NO;
        _no4.hidden = YES;
        _no5.hidden = YES;
        _no6.hidden = YES;
    } else if ([textFieldString length] == 2) {
        _no1.hidden = NO;
        _no2.hidden = NO;
        _no3.hidden = YES;
        _no4.hidden = YES;
        _no5.hidden = YES;
        _no6.hidden = YES;
    } else if ([textFieldString length] == 1) {
        _no1.hidden = NO;
        _no2.hidden = YES;
        _no3.hidden = YES;
        _no4.hidden = YES;
        _no5.hidden = YES;
        _no6.hidden = YES;
    } else if ([textFieldString length] == 0) {
        _no1.hidden = YES;
        _no2.hidden = YES;
        _no3.hidden = YES;
        _no4.hidden = YES;
        _no5.hidden = YES;
        _no6.hidden = YES;
    }  else if ([textFieldString length] > 0) {
        _no1.hidden = YES;
        _no2.hidden = YES;
        _no3.hidden = YES;
        _no4.hidden = YES;
        _no5.hidden = YES;
        _no6.hidden = YES;
    } else {
        
    }
}

@end
