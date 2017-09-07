//
//  MessageTopView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTopView : UIView

/**告警*/
@property (nonatomic ,strong) UIButton *alarmButton;

/**待检修*/
@property (nonatomic, strong) UIButton *examButton;

/**待保养*/
@property (nonatomic, strong) UIButton *maintainButton;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomView;

@end
