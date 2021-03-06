//
//  UserInfoCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "UserInfoCell.h"
@implementation UserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImageView];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.bottomLineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    self.headerImageView.frame = CGRectMake(10, 10, 46, 46);
    self.leftLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+10, 14, self.width - 80, 20);
    self.rightLabel.frame = CGRectMake(self.leftLabel.x, CGRectGetMaxY(self.leftLabel.frame)+2, self.width - 100, 20);
    self.leftLabel.text = [PersonInfo shareInstance].comName;
    
    NSString *usePhoneStr = [PersonInfo shareInstance].loginTextAccount;
    
    NSString *oneStr =[usePhoneStr substringToIndex:3];
    NSString *twoStr = [usePhoneStr substringFromIndex:9];
    
    self.rightLabel.text = [NSString stringWithFormat:@"帐号：%@******%@",oneStr,twoStr];

    NSString *imageStr = [PersonInfo shareInstance].comLogoUrl;
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@",PATH_AT_CACHEDIR(kUserImagesFolder),[imageStr lastPathComponent]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
     /**
     if (image!=nil)
         {
             //保存加载过后的图片到头像文件夹里
         NSData *imageData = UIImageJPEGRepresentation(image, 1);
         if (cachePath)
             {
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [BaseCacheHelper createFolder:cachePath isDirectory:NO];
                 [imageData writeToFile:cachePath atomically:NO];
             });
             }
         }
      */
     }];
    
    _bottomLineView.hidden = YES;
}


#pragma mark - getter setter

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.frame = CGRectMake(0, 0, 46, 46);
        _headerImageView.layer.cornerRadius = 23;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
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
        _rightLabel.textColor = [UIColor grayColor];
    }
    return _rightLabel;
}

-(UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.frame = CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5);
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
