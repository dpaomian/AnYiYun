    //
    //  MessageExamCell.m
    //  AnYiYun
    //
    //  Created by wwr on 2017/7/26.
    //  Copyright © 2017年 wwr. All rights reserved.
    //

#import "MessageExamCell.h"
#import "JXLayoutButton.h"

@interface MessageExamCell ()

@property (nonatomic, strong) MessageModel *useModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *middleLineLabel;

@property (nonatomic, strong) JXLayoutButton *dealButton;

@end

@implementation MessageExamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentView addSubview:self.middleLineLabel];
        
        [self.contentView addSubview:self.dealButton];
    }
    return self;
}

-(void)setCellContentWithModel:(MessageModel *)itemModel
{
    _useModel = itemModel;
    _titleLabel.text = itemModel.messageTitle;
    _timeLabel.text = @"";
    NSString *time = itemModel.time;
    if (time.length>14) {
        NSString *useTime = [itemModel.time substringFromIndex:5];
        _timeLabel.text = useTime;
    }
    _contentLabel.text =itemModel.messageContent;
}


#pragma mark - action

    //已处理
-(void)dealButtonAction:(id)sender
{
    [_cellDelegate dealExamButtonActionWithItem:_useModel];
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
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, 30)];
        _contentLabel.textColor = kAppTitleGrayColor;
        _contentLabel.font = SYSFONT_(13);
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}

- (UILabel *)middleLineLabel
{
    if (!_middleLineLabel) {
        _middleLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74.5, SCREEN_WIDTH, 0.5)];
        _middleLineLabel.backgroundColor = kAPPTableViewLineColor;
    }
    return _middleLineLabel;
}

- (JXLayoutButton *)dealButton
{
    if (!_dealButton) {
        _dealButton = [[JXLayoutButton alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 39)];
        [_dealButton setTitle:@"已处理" forState:UIControlStateNormal];
        [_dealButton setTitleColor:kAppTitleGrayColor forState:UIControlStateNormal];
        _dealButton.titleLabel.font = SYSFONT_(13);
        [_dealButton setImage:[UIImage imageNamed:@"deal_icon.png"] forState:UIControlStateNormal];
        _dealButton.layoutStyle = JXLayoutButtonStyleLeftImageRightTitle;
        [_dealButton addTarget:self action:@selector(dealButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _dealButton.imageSize = CGSizeMake(20, 20);
    }
    return _dealButton;
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
