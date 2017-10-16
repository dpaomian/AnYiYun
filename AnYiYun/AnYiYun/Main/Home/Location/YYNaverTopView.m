//
//  YYNaverTopView.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/16.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "YYNaverTopView.h"

@implementation YYNaverTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _navTypesView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0.0f, 22.88f, SCREEN_WIDTH, 64.0f-22.88f)];
    _navTypesView.backgroundColor = UIColorFromRGB(0x000000);
    [self addSubview:_navTypesView];
    _navTypesView.selectedIndex = 0;
    _navTypesView.titlesArray = @[@"步行",@"骑行",@"驾驶",@"公交"];
    _navTypesView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                
            } else {
                
            }
        }
    };
    
}

@end
