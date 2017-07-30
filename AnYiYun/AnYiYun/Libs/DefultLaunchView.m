//
//  DefultLaunchView.m
//  AnYiYun
//
//  Created by wwr on 2017/7/30.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "DefultLaunchView.h"

@interface DefultLaunchView()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation DefultLaunchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageView.image = [UIImage imageNamed:@"start_page640"];
        [self addSubview:imageView];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH-40, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:24];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"让设备管理变的更简单!";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
