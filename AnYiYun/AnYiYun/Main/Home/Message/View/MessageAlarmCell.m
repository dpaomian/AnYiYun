//
//  MessageAlarmCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MessageAlarmCell.h"
#import "JXLayoutButton.h"

@interface MessageAlarmCell ()

@property (nonatomic, strong) MessageModel *useModel;

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *middleLineLabel;

@property (nonatomic, strong) JXLayoutButton *dealButton;
@property (nonatomic, strong) JXLayoutButton *repairButton;
@property (nonatomic, strong) JXLayoutButton *curveButton;
@property (nonatomic, strong) JXLayoutButton *locationButton;

@property (nonatomic, strong) UILabel *dealLineLabel;
@property (nonatomic, strong) UILabel *repairLineLabel;
@property (nonatomic, strong) UILabel *curveLineLabel;

@end

@implementation MessageAlarmCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftImgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentView addSubview:self.middleLineLabel];
        
        [self.contentView addSubview:self.dealButton];
        [self.contentView addSubview:self.repairButton];
        [self.contentView addSubview:self.curveButton];
        [self.contentView addSubview:self.locationButton];
        
        [self.contentView addSubview:self.dealLineLabel];
        [self.contentView addSubview:self.repairLineLabel];
        [self.contentView addSubview:self.curveLineLabel];
    }
    return self;
}

-(void)setCellContentWithModel:(MessageModel *)itemModel
{
    _useModel = itemModel;
    _titleLabel.text = [NSString stringWithFormat:@"[告警]%@",itemModel.messageTitle];
    _timeLabel.text = @"";
    NSString *time = itemModel.time;
    if (time.length>14) {
        NSString *useTime = [itemModel.time substringFromIndex:5];
        _timeLabel.text = useTime;
    }
    _contentLabel.text =itemModel.messageContent;
    
    NSString *pointId = [BaseHelper isSpaceString:itemModel.pointId andReplace:@""];
    if (pointId.length==0)
        {
            [_curveButton setImage:[UIImage imageNamed:@"ployline_icon_gray.png"] forState:UIControlStateNormal];
        [_curveButton setTitleColor:kAppTitleLightGrayColor forState:UIControlStateNormal];
        _curveButton.userInteractionEnabled = NO;
    }
    else
        {
            [_curveButton setImage:[UIImage imageNamed:@"ployline_icon.png"] forState:UIControlStateNormal];
        [_curveButton setTitleColor:kAppTitleGrayColor forState:UIControlStateNormal];
        _curveButton.userInteractionEnabled = YES;
        }
}


#pragma mark - action

//待处理
-(void)dealButtonAction:(id)sender
{
    [_cellDelegate dealAlarmButtonActionWithItem:_useModel];
}
    //报修
-(void)repairButtonAction:(id)sender
{
    [_cellDelegate repairAlarmButtonActionWithItem:_useModel];
}
    //曲线
-(void)curveButtonAction:(id)sender
{
    [_cellDelegate curveAlarmButtonActionWithItem:_useModel];
}
    //定位
-(void)locationAction:(id)sender
{
    [_cellDelegate locationAlarmActionWithItem:_useModel];
}

#pragma mark - getter

-(UIImageView *)leftImgView
{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _leftImgView.image = [UIImage imageNamed:@"all_icon_14.png"];
    }
    return _leftImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-150, 40)];
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
        _dealButton = [[JXLayoutButton alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH/4, 39)];
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
- (JXLayoutButton *)repairButton
{
    if (!_repairButton) {
        _repairButton = [[JXLayoutButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 75, SCREEN_WIDTH/4, 39)];
        [_repairButton setTitle:@"报修" forState:UIControlStateNormal];
        [_repairButton setTitleColor:kAppTitleGrayColor forState:UIControlStateNormal];
        _repairButton.titleLabel.font = SYSFONT_(13);
        [_repairButton setImage:[UIImage imageNamed:@"repair_icon.png"] forState:UIControlStateNormal];
        _repairButton.layoutStyle = JXLayoutButtonStyleLeftImageRightTitle;
        [_repairButton addTarget:self action:@selector(repairButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _repairButton.imageSize = CGSizeMake(20, 20);
    }
    return _repairButton;
}

- (JXLayoutButton *)curveButton
{
    if (!_curveButton) {
        _curveButton = [[JXLayoutButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*2, 75, SCREEN_WIDTH/4, 39)];
        [_curveButton setTitle:@"曲线" forState:UIControlStateNormal];
        [_curveButton setTitleColor:kAppTitleGrayColor forState:UIControlStateNormal];
        _curveButton.titleLabel.font = SYSFONT_(13);
        [_curveButton setImage:[UIImage imageNamed:@"ployline_icon.png"] forState:UIControlStateNormal];
        _curveButton.layoutStyle = JXLayoutButtonStyleLeftImageRightTitle;
        [_curveButton addTarget:self action:@selector(curveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _curveButton.imageSize = CGSizeMake(20, 20);
    }
    return _curveButton;
}

- (JXLayoutButton *)locationButton
{
    if (!_locationButton) {
        _locationButton = [[JXLayoutButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 75, SCREEN_WIDTH/4, 39)];
        [_locationButton setTitle:@"定位" forState:UIControlStateNormal];
        [_locationButton setTitleColor:kAppTitleGrayColor forState:UIControlStateNormal];
        _locationButton.titleLabel.font = SYSFONT_(13);
        [_locationButton setImage:[UIImage imageNamed:@"location_icon.png"] forState:UIControlStateNormal];
        _locationButton.layoutStyle = JXLayoutButtonStyleLeftImageRightTitle;
        [_locationButton addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
        _locationButton.imageSize = CGSizeMake(20, 20);
    }
    return _locationButton;
}

- (UILabel *)dealLineLabel
{
    if (!_dealLineLabel) {
        _dealLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 80, 0.5, 25)];
        _dealLineLabel.backgroundColor = kAPPTableViewLineColor;
    }
    return _dealLineLabel;
}

- (UILabel *)repairLineLabel
{
    if (!_repairLineLabel) {
        _repairLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*2, 80, 0.5, 25)];
        _repairLineLabel.backgroundColor = kAPPTableViewLineColor;
    }
    return _repairLineLabel;
}

- (UILabel *)curveLineLabel
{
    if (!_curveLineLabel) {
        _curveLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 80, 0.5, 25)];
        _curveLineLabel.backgroundColor = kAPPTableViewLineColor;
    }
    return _curveLineLabel;
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
