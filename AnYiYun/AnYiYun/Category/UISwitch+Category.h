//
//  UISwitch+Category.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^SwitchChange)(UISwitch *sender);

@interface UISwitch (Category)

-(void)switchChangeHandle:(SwitchChange)touchHandler;

@end
