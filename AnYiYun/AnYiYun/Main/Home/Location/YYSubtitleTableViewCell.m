//
//  YYSubtitleTableViewCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/22.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYSubtitleTableViewCell.h"

@implementation YYSubtitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
