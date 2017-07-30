//
//  MonthCalendarViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/30.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MonthCalendarViewController.h"
#import "YYCalendarModel.h"
#import "YYDatePicker.h"

@interface MonthCalendarViewController ()

@end

@implementation MonthCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak MonthCalendarViewController *ws = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor clearColor];
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, NAV_HEIGHT+1.0f)];
    navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navigationView];
    
    UIView *bgdView = [[UIView alloc] initWithFrame:CGRectZero];
    bgdView.backgroundColor = [UIColor whiteColor];
    bgdView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bgdView];
    
    YYDatePicker *datePicker = [ [ YYDatePicker alloc] initWithFrame:self.view.frame];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    datePicker.backgroundColor = [UIColor whiteColor];
    /*获取当前时间*/
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    datePicker.yearString = [NSString stringWithFormat:@"%d年",nowComponents.year];
    datePicker.monthString = [NSString stringWithFormat:@"%d月",nowComponents.month];
    [bgdView addSubview:datePicker];
    
    UIButton *okbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    okbutton.translatesAutoresizingMaskIntoConstraints = NO;
    [okbutton setTitle:@"确定" forState:UIControlStateNormal];
    [okbutton setTitleColor:UIColorFromRGB(0xF0F0F0) forState:UIControlStateNormal];
    [okbutton setBackgroundColor:UIColorFromRGB(0x5987F8)];
    okbutton.layer.cornerRadius = 4.0f;
    okbutton.clipsToBounds = YES;
    [okbutton buttonClickedHandle:^(UIButton *sender) {
        /*!消失并保留时间*/
        DLog(@"%@/%@",datePicker.yearString,datePicker.monthString);
        NSInteger year = [[datePicker.yearString stringByReplacingOccurrencesOfString:@"年" withString:@""] integerValue];
        NSInteger month = [[datePicker.monthString stringByReplacingOccurrencesOfString:@"月" withString:@""] integerValue];
        _choiceMonthHandle(year, month);
        [ws dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
    [bgdView addSubview:okbutton];
    [bgdView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[datePicker]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(datePicker)]];
    [bgdView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[okbutton]-|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(okbutton)]];
    [bgdView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[datePicker]-[okbutton(==34)]-8-|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(datePicker, okbutton)]];
    
    UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    touchButton.translatesAutoresizingMaskIntoConstraints = NO;
    touchButton.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
    [touchButton buttonClickedHandle:^(UIButton *sender) {
        [ws dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
    [self.view addSubview:touchButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgdView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(bgdView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[touchButton]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(touchButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[bgdView(==240)][touchButton]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(bgdView, touchButton)]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
