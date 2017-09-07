//
//  UserInfoCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 个人资料cell
 */
@interface UserInfoCell : UITableViewCell

/**left*/
@property (nonatomic, strong) UILabel *leftLabel;

/**right*/
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong)UIView *bottomLineView;

@end
