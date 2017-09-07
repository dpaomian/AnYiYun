//
//  HelpViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/2.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface HelpViewController : BaseViewController <UIWebViewDelegate>

/*!webView*/
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, copy) void (^backHandle)();

@end
