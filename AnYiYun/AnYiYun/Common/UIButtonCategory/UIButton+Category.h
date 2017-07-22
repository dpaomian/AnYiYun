//
//  UIButton+Category.h
//  AustraliaCustomer
//
//  Created by 韩亚周 on 17/2/22.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ClickedHandle)(UIButton *sender);

@interface UIButton (Category)

-(void)buttonClickedHandle:(ClickedHandle)touchHandler;

@end
