//
//  UISwitch+Category.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "UISwitch+Category.h"

static const void *touchKey = &touchKey;

@implementation UISwitch (Category)

-(void)switchChange:(UIButton *)sender
{
    ClickedHandle blockHandle = objc_getAssociatedObject(self, &touchKey);
    if (blockHandle) {
        blockHandle(sender);
    }
}

-(void)switchChangeHandle:(SwitchChange)touchHandler
{
    objc_setAssociatedObject(self, &touchKey, touchHandler, OBJC_ASSOCIATION_RETAIN);
    [self addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
}

@end
