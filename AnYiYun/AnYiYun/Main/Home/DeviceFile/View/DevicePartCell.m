//
//  DevicePartCell.m
//  AnYiYun
//
//  Created by wuwanru on 29/7/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "DevicePartCell.h"

@interface DevicePartCell()
{
    UILabel         *leftLabel;
    UILabel         *rightLabel;
}
@end
@implementation DevicePartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 44)];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.textColor = kAppTitleBlackColor;
        leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.numberOfLines = 1;
        [self.contentView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, 44)];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.textColor = kAppTitleGrayColor;
        rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.font = [UIFont systemFontOfSize:12];
        rightLabel.numberOfLines = 2;
        [self.contentView addSubview:rightLabel];
        
    }
    return self;
}


- (void)setCellContentWithLeftLabelStr:(NSString *)leftStr andRightLabelStr:(NSString *)rightStr
{
    leftLabel.text = leftStr;
    rightLabel.text = rightStr;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
