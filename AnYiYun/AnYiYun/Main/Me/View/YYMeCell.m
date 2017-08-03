//
//  YYMeCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/4.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYMeCell.h"

@implementation YYMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
