//
//  YYDatePicker.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "YYDatePicker.h"

@interface YYDatePicker ()

@property (nonatomic, strong) NSMutableArray *dateArray;

@end

@implementation YYDatePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *yearsMutableArray = [NSMutableArray array];
        NSMutableArray *daysMutableArray = [NSMutableArray array];
        for (int i = 1980; i < 2100; i ++) {
            [yearsMutableArray addObject:[NSString stringWithFormat:@"%d年",i]];
        }
        for (int i = 1; i < 13; i ++) {
            [daysMutableArray addObject:[NSString stringWithFormat:@"%d月",i]];
        }
        _dateArray = [@[yearsMutableArray, daysMutableArray] mutableCopy];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setYearString:(NSString *)yearString {
    _yearString = yearString;
    NSInteger idx = [_dateArray[0] indexOfObject:yearString];
    [self selectRow:idx inComponent:0 animated:YES];
}

- (void)setMonthString:(NSString *)monthString {
    _monthString = monthString;
    NSInteger idx = [_dateArray[1] indexOfObject:monthString];
    [self selectRow:idx inComponent:1 animated:YES];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return [_dateArray count];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *currentArray = _dateArray[component];
    return [currentArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *currentArray = _dateArray[component];
    return [currentArray objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component {
    NSArray *currentArray = _dateArray[component];
    if (component == 0) {
        self.yearString = [currentArray objectAtIndex:row];
    } else {
        self.monthString = [currentArray objectAtIndex:row];
    }
}

@end
