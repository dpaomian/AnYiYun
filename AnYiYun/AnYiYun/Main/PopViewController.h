//
//  PopViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/1.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UITextView+DisableCopy.h"

@interface PopViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;

@property (weak, nonatomic) IBOutlet UIView *inputBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (nonatomic, assign) BOOL noHelp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end
