//
//  RealtimeMonitoringChildCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "RealtimeMonitoringChildCell.h"

@implementation RealtimeMonitoringChildCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
