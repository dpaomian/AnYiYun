//
//  StatusBarOverlay.h
//  BaseProject
//
//  Created by wxs on 16/7/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusBarOverlay : UIView

{
    UIView *contentView;
    
    UILabel *textLabel;
    
    NSString *_message;
    
    UIView *_bgView;
}
@property (nonatomic, retain) UIView *contentView;

@property (nonatomic, retain) UILabel *textLabel;

@property (retain, nonatomic) NSString *message;

@property (assign, nonatomic) BOOL shouldHideOnTap;

@property (assign, nonatomic) BOOL manuallyHide;

@property (assign, nonatomic) NSTimeInterval timeOnScreen;

@property (readonly, nonatomic) BOOL isHidden;

+ (void)initAnimationWithAlertString:(NSString*)str;

+ (void)initAnimationWithAlertString:(NSString*)str theImage:(UIImage*)image;

@end
