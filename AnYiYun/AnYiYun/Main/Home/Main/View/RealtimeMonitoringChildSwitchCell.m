//
//  RealtimeMonitoringChildSwitchCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "RealtimeMonitoringChildSwitchCell.h"

@implementation RealtimeMonitoringChildSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _yySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
