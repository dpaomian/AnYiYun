//
//  UIButton+Category.m
//  AustraliaCustomer
//
//  Created by 韩亚周 on 17/2/22.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "UIButton+Category.h"

static const void *touchKey = &touchKey;

@implementation UIButton (Category)

-(void)touchUpInside:(UIButton *)sender
{
    ClickedHandle blockHandle = objc_getAssociatedObject(self, &touchKey);
    if (blockHandle) {
        blockHandle(sender);
    }
}

-(void)buttonClickedHandle:(ClickedHandle)touchHandler
{
    objc_setAssociatedObject(self, &touchKey, touchHandler, OBJC_ASSOCIATION_RETAIN);
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

@end
