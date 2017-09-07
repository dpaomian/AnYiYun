//
//  YYDatePicker.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!年月选择器*/
@interface YYDatePicker : UIPickerView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSString *yearString;
@property (nonatomic, strong) NSString *monthString;

@end
