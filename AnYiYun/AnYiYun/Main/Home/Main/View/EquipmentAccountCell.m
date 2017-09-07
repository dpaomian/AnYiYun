//
//  EquipmentAccountCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "EquipmentAccountCell.h"

@implementation EquipmentAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
