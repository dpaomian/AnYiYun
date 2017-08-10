//
//  HistoryMessageCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/27.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HistoryMessageCell.h"
#import "DBDaoDataBase.h"

@interface HistoryMessageCell ()

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *middleLineLabel;


@end

@implementation HistoryMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftImgView];
        [self.contentView addSubview:self.numLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentView addSubview:self.middleLineLabel];
    }
    return self;
}

-(void)setCellContentWithModel:(HistoryMessageModel *)itemModel
{
    if ([BaseHelper isSpaceString:itemModel.iconUrl andReplace:@""].length>0)
    {
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:itemModel.iconUrl] placeholderImage:nil];
    }
         else
         {
             self.leftImgView.image = [UIImage imageNamed:@"all_icon_14.png"];
         }
    
    
    _titleLabel.text = itemModel.typeName;
    
    _numLabel.hidden = YES;
    if (itemModel.num>0)
    {
        _numLabel.hidden = NO;
        _numLabel.text = [NSString stringWithFormat:@"%ld",itemModel.num];
        if (itemModel.num>99)
        {
            _numLabel.text = @"99+";
        }
    }
    _contentLabel.text =itemModel.recentMes;
    
    _timeLabel.text = @"";
    if (itemModel.rtime>0)
    {
        _timeLabel.text = [BaseHelper getShowTimeWithLong:itemModel.rtime];
    }
}

#pragma mark - getter

-(UIImageView *)leftImgView
{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _leftImgView.image = [UIImage imageNamed:@"all_icon_14.png"];
        _leftImgView.layer.masksToBounds = YES;
        //_leftImgView.layer.cornerRadius = 30;
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImgView.clipsToBounds = YES;
    }
    return _leftImgView;
}


- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 20, 20)];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = SYSFONT_(12);
        _numLabel.backgroundColor = [UIColor redColor];
        _numLabel.layer.masksToBounds = YES;
        _numLabel.layer.cornerRadius = 10;
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-190, 40)];
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
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-40, 30)];
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
