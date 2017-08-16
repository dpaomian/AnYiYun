//
//  DefultLaunchView.m
//  AnYiYun
//
//  Created by wwr on 2017/7/30.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "DefultLaunchView.h"

@interface DefultLaunchView()


@end

@implementation DefultLaunchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageView.image = [UIImage imageNamed:@"start_page.png"];
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
        [self addSubview:self.aniamtionImageView];
    }
    
    return self;
}

#pragma mark - getter

- (FLAnimatedImageView *)aniamtionImageView
{
    if (!_aniamtionImageView) {
        _aniamtionImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(-50, 180, kScreen_Width+100, 90)];
        NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:@"launch_defult" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _aniamtionImageView.animatedImage = image;
    }
    return _aniamtionImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
