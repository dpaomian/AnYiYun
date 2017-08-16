//
//  HistoryDetailCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/27.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HistoryDetailCell.h"

@interface HistoryDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *middleLineLabel;


@end

@implementation HistoryDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentView addSubview:self.middleLineLabel];
    }
    return self;
}

-(void)setCellContentWithModel:(MessageModel *)itemModel
{
    if ([itemModel.isRead isEqualToString:@"0"])
    {
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _contentLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    else
    {
        _titleLabel.font = SYSFONT_(14);
        _contentLabel.font = SYSFONT_(13);
    }
    _titleLabel.text = itemModel.messageTitle;
    _timeLabel.text = [BaseHelper getShowTimeWithLong:itemModel.ctime];
    
    _contentLabel.text =itemModel.messageContent;
}

#pragma mark - getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-120, 40)];
        _titleLabel.textColor = kAppTitleBlackColor;
        _titleLabel.font = SYSFONT_(14);
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 0, 100, 40)];
        _timeLabel.textColor = kAppTitleGrayColor;
        _timeLabel.font = SYSFONT_(12);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 30)];
        _contentLabel.textColor = kAppTitleGrayColor;
        _contentLabel.font = SYSFONT_(13);
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}

- (UILabel *)middleLineLabel
{
    if (!_middleLineLabel) {
        _middleLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5)];
        _middleLineLabel.backgroundColor = kAPPTableViewLineColor;
    }
    return _middleLineLabel;
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
