//
//  UserInfoCell.h
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
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
