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
        imageView.image = [UIImage imageNamed:@"start_page"];
        [self addSubview:imageView];
        
        
        UIImageView *logoImageView = [[UIImageView alloc]init];
        logoImageView.frame = CGRectMake((SCREEN_WIDTH-150)/2, 80, 50, 50);
        logoImageView.image = [UIImage imageNamed:@"logo_white.png"];
        [self addSubview:logoImageView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x, logoImageView.frame.origin.y, 100, 50);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:28];
        titleLabel.text = @"安易云";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self  addSubview:titleLabel];
        
        
        //读取gif图片数据
        NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"launch_defult" ofType:@"gif"]];
        //UIWebView生成
        UIWebView *imageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 180, kScreen_Width, 70)];
        //用户不可交互
        imageWebView.userInteractionEnabled = NO;
        //加载gif数据
        [imageWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
        //视图添加此gif控件
        [self addSubview:imageWebView];
        
        //[self addSubview:self.titleLabel];
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
