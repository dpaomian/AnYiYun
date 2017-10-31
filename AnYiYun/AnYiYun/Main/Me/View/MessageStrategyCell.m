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
    UIImage* img=[UIImage imageNamed:@"rectangle.png"];
    img= [img resizableImageWithCapInsets:UIEdgeInsetsMake(14,10,10,40) resizingMode:UIImageResizingModeStretch];
    self.alertImageView.image = img;
    self.alertImageView2.image = img;
    _textField2.rightView = [[UIImageView alloc] initWithImage:img];
    _textField1.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Alert.png"]];
    _textField2.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Alert.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark UITextFieldDelegate -

- (NSString *) trimming:(NSString *)s {
    
    return [s stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_textEditBeginHandle) {
        _textEditBeginHandle(self, textField);
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (_textEndEditHandle) {
//        _textEndEditHandle(self, textField);
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _alertImageView.hidden = YES;
//    [NSCharacterSet decimalDigitCharacterSet];
    if ([self trimming:[textField.text stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]].length > 0) {
        DLog(@"不是纯数字");
        return NO;
    }else{
        DLog(@"纯数字！");
        NSString *textFieldString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if ([textFieldString length]>_maxLength) {
            if ([string isEqualToString:@""]) {
                if (_textChangeHandle) {
                    DLog(@"大于3 --->%@",[textFieldString substringToIndex:[textFieldString length]-1]);
                    _textChangeHandle(self, textField, [textFieldString substringToIndex:[textFieldString length]-1]);
                }
                return YES;
            } else {
                return NO;
            }
        } else {
            if ([string isEqualToString:@""]) {
                if (_textChangeHandle) {
                    DLog(@"小于3 1--->%@",[textFieldString substringToIndex:[textFieldString length]-1]);
                    _textChangeHandle(self, textField, [textFieldString substringToIndex:[textFieldString length]-1]);
                }
                
            } else {
                DLog(@"小于3 --->%@",textFieldString);
                _textChangeHandle(self, textField, textFieldString);
            }
            return YES;
        }
    }
}

@end
