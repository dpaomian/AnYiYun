//
//  HomeMessageCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HomeMessageCell.h"

@interface HomeMessageCell ()
{
    UILabel         *titleLabel;
    UILabel         *descLabel;
}
@end

@implementation HomeMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        {
        UILabel *tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 60, 20)];
        tapLabel.backgroundColor = kAppTitleRedColor;
        tapLabel.layer.masksToBounds=YES;
        tapLabel.layer.cornerRadius = 4;
        tapLabel.text = @"消息中心";
        tapLabel.font = [UIFont systemFontOfSize:14];
        tapLabel.textColor = [UIColor whiteColor];
        tapLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tapLabel];

        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 30)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.text = @"您有新消息了";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 85, SCREEN_WIDTH-60, 20)];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.textColor = kAPPBlueColor;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize:10];
        descLabel.text = @"立即查看";
        [self.contentView addSubview:descLabel];
        
        }
    return self;
}

-(void)setCellContentWithType:(NSString *)type withDay:(NSString *)day
{
    descLabel.hidden = NO;
    titleLabel.text = @"您有新消息了";
    if ([type isEqualToString:@"2"])
        {
        descLabel.hidden = YES;
        titleLabel.text = [NSString stringWithFormat:@"您已安全运行%@天",day];
    }
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
