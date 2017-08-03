//
//  MeCell.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MeCell.h"

@interface MeCell ()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UILabel *rightLabel;



@end

@implementation MeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightLabel];
        [self addSubview:self.bottomLineView];
    }
    return self;
}


-(void)setCellContentWithTitle:(NSString *)titleString withImageString:(NSString *)imageString withType:(NSString *)type
{
    _rightLabel.text = @"";
    _rightLabel.hidden = YES;
    
    
    _leftImageView.image = [UIImage imageNamed:imageString];
    _leftLabel.text = titleString;
    [_leftLabel sizeToFit];
    _leftLabel.frame = CGRectMake(44, 0, _leftLabel.frame.size.width, 44);
    if ([type isEqualToString:@"1"])
        {
            //有未读消息
        _rightLabel.hidden = NO;
        _rightLabel.backgroundColor = [UIColor redColor];
        _rightLabel.frame = CGRectMake(_leftLabel.frame.size.width+_leftLabel.frame.origin.y+5, 17, 10, 10);
        _rightLabel.layer.masksToBounds = YES;
        _rightLabel.layer.cornerRadius = 5;
    }
    else if ([type isEqualToString:@"2"])
        {
            //清除缓存
        float sizeCache = [self getCacheSize];
        
        if (sizeCache>0)
            {
            NSString *cacheSizeString = [BaseHelper filterNullObj:[NSString stringWithFormat:@"%.2fM",sizeCache]];
            _rightLabel.text = cacheSizeString;
            [_rightLabel sizeToFit];
            _rightLabel.hidden = NO;
            _rightLabel.backgroundColor = [UIColor redColor];
            _rightLabel.frame = CGRectMake(_leftLabel.frame.size.width+_leftLabel.frame.origin.y+5, 14.5, _rightLabel.frame.size.width+20, 15);
            _rightLabel.layer.masksToBounds = YES;
            _rightLabel.layer.cornerRadius = 7.5;
        }
        }
}

-(float)getCacheSize
{
    float cacheSize = 2;
    return cacheSize;
}

#pragma mark - getter setter

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.frame = CGRectMake(10, 10, 18, 18);
    }
    return _leftImageView;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = SYSFONT_(14);
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = SYSFONT_(12);
    }
    return _rightLabel;
}

-(UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.frame = CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5);
        _bottomLineView.backgroundColor = kAPPTableViewLineColor;
    }
    return _bottomLineView;
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
