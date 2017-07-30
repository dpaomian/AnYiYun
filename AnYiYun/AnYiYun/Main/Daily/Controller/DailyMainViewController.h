//
//  DailyMainViewController.h
//  AnYiYun
//
//  Created by wwr on 2017/7/20.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYCalendarView.h"
#import "CalendarViewController.h"
#import "MonthCalendarViewController.h"
#import "MBProgressHUD+YY.h"

/**
 日报
 */
@interface DailyMainViewController : BaseViewController <UIWebViewDelegate>

/*!webView*/
@property (strong, nonatomic) UIWebView *webView;
/*!webview需要加载的地址*/
@property (strong, nonatomic) UILabel   *placeHoldLable;
@property (strong, nonatomic) MonthCalendarViewController *monthCalenderVC;

@end
