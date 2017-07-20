//
//  UIViewController+Swizzling.m
//  NIM
//
//  Created by chris on 15/6/15.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import "SwizzlingDefine.h"

@implementation UIViewController (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIViewController class] ,@selector(viewWillAppear:), @selector(swizzling_viewWillAppear:));
        swizzling_exchangeMethod([UIViewController class] ,@selector(viewDidAppear:), @selector(swizzling_viewDidAppear:));
        swizzling_exchangeMethod([UIViewController class] ,@selector(viewWillDisappear:), @selector(swizzling_viewWillDisappear:));
        
        swizzling_exchangeMethod([UIViewController class] ,@selector(viewDidLoad),    @selector(swizzling_viewDidLoad));
//        swizzling_exchangeMethod([UIViewController class], @selector(initWithNibName:bundle:), @selector(swizzling_initWithNibName:bundle:));
    });
}

#pragma mark - ViewDidLoad
- (void)swizzling_viewDidLoad{
    [self swizzling_viewDidLoad];
}


#pragma mark - InitWithNibName:bundle:
////如果希望vchidesBottomBarWhenPushed为NO的话，请在vc init方法之后调用vc.hidesBottomBarWhenPushed = NO;
//- (instancetype)swizzling_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    id instance = [self swizzling_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (instance) {
//        self.hidesBottomBarWhenPushed = YES;
//    }
//    return instance;
//}
#pragma mark - ViewWillAppear
static char UIFirstResponderViewAddress;

- (void)swizzling_viewWillAppear:(BOOL)animated{
    NSLog(@"class name>> %@",NSStringFromClass([self class]));
    
    
    [self swizzling_viewWillAppear:animated];

}

#pragma mark - ViewDidAppear
- (void)swizzling_viewDidAppear:(BOOL)animated{
    [self swizzling_viewDidAppear:animated];
    UIView *view = objc_getAssociatedObject(self, &UIFirstResponderViewAddress);
    [view becomeFirstResponder];
}


#pragma mark - ViewWillDisappear

- (void)swizzling_viewWillDisappear:(BOOL)animated{
    [self swizzling_viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIView *view = (UIView *)[UIResponder currentFirstResponder];
    if ([view isKindOfClass:[UIView class]] && view.viewController == self) {
        objc_setAssociatedObject(self, &UIFirstResponderViewAddress, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [view resignFirstResponder];
    }else{
        objc_setAssociatedObject(self, &UIFirstResponderViewAddress, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


@end
