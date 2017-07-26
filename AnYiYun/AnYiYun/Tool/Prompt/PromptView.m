//
//  PromptView.m
//  xuexin
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 mx. All rights reserved.
//

#import "PromptView.h"

@interface PromptView()
{
    UILabel *titleLabel;
    UILabel *promptLabel;
}
@end


@implementation PromptView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-107)/2, 80, 107, 107)];
        bgImageView.image = [UIImage imageNamed:@"main_defult_none.png"];
        [self addSubview:bgImageView];
        
        titleLabel= [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0, bgImageView.frame.size.height+bgImageView.frame.origin.y+30, frame.size.width, 20);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = RGBA(205, 201, 201, 1);
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        promptLabel= [[UILabel alloc]init];
        promptLabel.frame = CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y + 10, frame.size.width, 20);
        promptLabel.font = [UIFont systemFontOfSize:14];
        promptLabel.textColor = RGBA(205, 201, 201, 1);
        promptLabel.backgroundColor=[UIColor clearColor];
        promptLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:promptLabel];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andOneLabelText:(NSString *)oneLabelString andTwoLabelText:(NSString *)twoLabelString
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-107)/2, 80, 107, 107)];
        bgImageView.image = [UIImage imageNamed:@"main_defult_none.png"];
        [self addSubview:bgImageView];
        
        titleLabel= [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0, bgImageView.frame.size.height+bgImageView.frame.origin.y+30, frame.size.width, 20);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = RGBA(205, 201, 201, 1);
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = oneLabelString;
        [self addSubview:titleLabel];
        
        promptLabel= [[UILabel alloc]init];
        promptLabel.frame = CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y + 10, frame.size.width, 20);
        promptLabel.font = [UIFont systemFontOfSize:14];
        promptLabel.textColor = RGBA(205, 201, 201, 1);
        promptLabel.backgroundColor=[UIColor clearColor];
        promptLabel.textAlignment=NSTextAlignmentCenter;
        promptLabel.text = twoLabelString;
        [self addSubview:promptLabel];
        
    }
    return self;
}

- (void)setOneLabelText:(NSString *)oneLabelString andTwoLabelText:(NSString *)twoLabelString andSign:(NSString *)signString
{
    titleLabel.text = oneLabelString;
    promptLabel.text = twoLabelString;
}


@end
