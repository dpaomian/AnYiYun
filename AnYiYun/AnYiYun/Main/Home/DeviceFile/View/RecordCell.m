//
//  RecordCell.m
//  AnYiYun
//
//  Created by wuwanru on 29/7/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "RecordCell.h"

@interface RecordCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *cellLineLabel;

@end

@implementation RecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.usernameLabel];
        
        [self.contentView addSubview:self.cellLineLabel];
    }
    return self;
}

-(void)setCellContentWithModel:(MessageModel *)itemModel
{
    _titleLabel.text = itemModel.messageTitle;
    _timeLabel.text = @"";
    NSString *time = itemModel.time;
    if (time.length>16) {
        NSString *useTime = [itemModel.time substringToIndex:15];
        _timeLabel.text = useTime;
    }
    _usernameLabel.text =itemModel.userName;
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = kAppTitleBlackColor;
        _titleLabel.font = SYSFONT_(14);
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 40, 100, 20)];
        _usernameLabel.textColor = kAppTitleGrayColor;
        _usernameLabel.font = SYSFONT_(12);
        _usernameLabel.textAlignment = NSTextAlignmentRight;
        _usernameLabel.backgroundColor = [UIColor clearColor];
    }
    return _usernameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 60, 100, 20)];
        _timeLabel.textColor = kAppTitleGrayColor;
        _timeLabel.font = SYSFONT_(12);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeLabel;
}



- (UILabel *)cellLineLabel
{
    if (!_cellLineLabel) {
        _cellLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84.5, SCREEN_WIDTH, 0.5)];
        _cellLineLabel.backgroundColor = kAPPTableViewLineColor;
    }
    return _cellLineLabel;
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
