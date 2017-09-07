//
//  UIButton+Category.h
//  AustraliaCustomer
//
//  Created by 韩亚周 on 17/2/22.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ClickedHandle)(UIButton *sender);

@interface UIButton (Category)

-(void)buttonClickedHandle:(ClickedHandle)touchHandler;

@end
