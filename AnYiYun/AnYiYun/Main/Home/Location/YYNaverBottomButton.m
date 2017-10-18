//
//  YYNaverBottomButton.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYNaverBottomButton.h"

@implementation YYNaverBottomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
        self.layer.borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor whiteColor];
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, SCREEN_WIDTH-20, 22)];
        _titleLab.font = [UIFont systemFontOfSize:14.0f];
        _titleLab.text = @"999米";
        [self addSubview:_titleLab];
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_titleLab.frame)+8, SCREEN_WIDTH-20, 22)];
        _contentLab.font = [UIFont systemFontOfSize:12.0f];
        _contentLab.text = @"[上滑查看详情]";
        _contentLab.textColor = UIColorFromRGB(0x666666);
        [self addSubview:_contentLab];
    }
    return self;
}

@end
