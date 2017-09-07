//
//  HomeMessageCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/25.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "HomeMessageCell.h"

@interface HomeMessageCell ()
{
    UILabel         *tapLabel;
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
        tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 70, 20)];
        tapLabel.backgroundColor = kAppTitleRedColor;
        tapLabel.layer.masksToBounds=YES;
        tapLabel.layer.cornerRadius = 4;
        tapLabel.text = @"消息中心";
        tapLabel.font = [UIFont systemFontOfSize:14];
        tapLabel.textColor = [UIColor whiteColor];
        tapLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tapLabel];

        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 30)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.text = @"您有新消息了";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, SCREEN_WIDTH-60, 20)];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.textColor = kAPPBlueColor;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize:10];
        
        [self.contentView addSubview:descLabel];
        
        }
    return self;
}

-(void)setCellContentWithType:(NSString *)type withDay:(NSString *)day
{
    if ([type isEqualToString:@"2"])
        {
        titleLabel.text = @"安易云已为您服务";
        tapLabel.backgroundColor = RGB(74, 191, 131);
        descLabel.font = [UIFont boldSystemFontOfSize:16];
        descLabel.text = day;
        descLabel.textColor = RGB(74, 191, 131);
    }
    else
        {
        titleLabel.text = @"您有新消息了";
        tapLabel.backgroundColor = kAppTitleRedColor;
        descLabel.font = [UIFont systemFontOfSize:10];
        descLabel.text = @"立即查看";
        descLabel.textColor = kAPPBlueColor;
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
