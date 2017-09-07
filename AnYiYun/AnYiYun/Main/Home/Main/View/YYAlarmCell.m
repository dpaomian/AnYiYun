//
//  YYAlarmCell.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "YYAlarmCell.h"

@implementation YYAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    __weak YYAlarmCell *ws = self;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_dealBtn buttonClickedHandle:^(UIButton *sender) {
        ws.btnClickedHandle(ws, YYAlarmCellButtonTypeDeal);
    }];
    [_repairBtn buttonClickedHandle:^(UIButton *sender) {
        ws.btnClickedHandle(ws, YYAlarmCellButtonTypeRepair);
    }];
    [_curveBtn buttonClickedHandle:^(UIButton *sender) {
        ws.btnClickedHandle(ws, YYAlarmCellButtonTypeCurve);
    }];
    [_locationBtn buttonClickedHandle:^(UIButton *sender) {
        ws.btnClickedHandle(ws, YYAlarmCellButtonTypeLocation);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
