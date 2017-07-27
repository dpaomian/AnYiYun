//
//  LoadDatectionHeaderView.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoadDatectionHeaderView.h"

@implementation LoadDatectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self sendSubviewToBack:self.bgView];
    self.bgView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.bgView.layer.borderWidth = 0.66f;
    self.bgView.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
    
    __weak LoadDatectionHeaderView *ws = self;
    [_touchButton buttonClickedHandle:^(UIButton *sender) {
        ws.markButton.selected =! ws.markButton.selected;
        if (ws.headerTouchHandle) {
            ws.headerTouchHandle(ws,ws.markButton.selected);
        }
    }];
}

@end
