//
//  PromptView.h
//  xuexin
//
//  Created by 韩亚周 on 15/8/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView

//初始化View
- (id)initWithFrame:(CGRect)frame andOneLabelText:(NSString *)oneLabelString andTwoLabelText:(NSString *)twoLabelString;

//更改View上label的值
- (void)setOneLabelText:(NSString *)oneLabelString andTwoLabelText:(NSString *)twoLabelString andSign:(NSString *)signString;

@end
