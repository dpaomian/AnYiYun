//
//  StatusBarOverlay.m
//  BaseProject
//
//  Created by 韩亚周 on 16/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "StatusBarOverlay.h"
#define STATUS_BAR_ORIENTATION [UIApplication sharedApplication].statusBarOrientation
#define ROTATION_ANIMATION_DURATION [UIApplication sharedApplication].statusBarOrientationAnimationDuration
#define ANIMATION_TIME 1
#define ANIMATION_STATE_TIME 4

#define LEFT_PADDING 30
#define IMAGE_STYLE_WIDETH 120
#define IMAGE_STYLE_HEIGHT 30

#define LABEL_LEFT_PADDING 10
#import "StatusBarOverlay.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageLabel.h"

#define THEME_BLUE_COLOR RGBA(255, 183, 85, 0.75)

NSTimeInterval const kTimeOnScreenDefault       = 1.25;
@implementation StatusBarOverlay
@synthesize contentView;
@synthesize textLabel;
@synthesize message = _message;

+ (void)initAnimationWithAlertString:(NSString*)str
{
    StatusBarOverlay *popView = [[self alloc]initWithText:str image:nil];
    [popView showView];
}

+ (void)initAnimationWithAlertString:(NSString*)str theImage:(UIImage*)image
{
    StatusBarOverlay *popView = [[self alloc]initWithText:str image:image];
    [popView showView];
}

- (id)initWithText:(NSString*)str image:(UIImage*)image{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (image) {
            [self initImage:image message:str];
        }else{
            [self initNormalMessage:str];
        }
    }
    
    return self;
}

- (void)initNormalMessage:(NSString *)str{
    MAIN(^{
        self.frame = CGRectMake(LEFT_PADDING,64, [UIScreen mainScreen].bounds.size.width - 2*LEFT_PADDING, 25);
        //内容视图
        self.backgroundColor = RGB(51, 51, 51);
        self.layer.cornerRadius = 3.0;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.message = str;
        self.timeOnScreen = 3;
        
        //添加textLabel
        UILabel *_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, CGRectGetWidth(self.frame)- 2*40, CGRectGetHeight(self.frame))];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        _textLabel.numberOfLines = 0;
        _textLabel.text = str;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        UIFont *font = [UIFont systemFontOfSize:14];
        CGRect rect = [self.message boundingRectWithSize:CGSizeMake(_textLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        _textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
        CGSize sizeBackGround = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*LEFT_PADDING, CGRectGetHeight(rect) + 2*LABEL_LEFT_PADDING);
        if (rect.size.width + 40 > sizeBackGround.width) {
            self.frame = CGRectMake(0, 0,  sizeBackGround.width, sizeBackGround.height);
        }else{
            self.frame = CGRectMake(0, 0,  rect.size.width + 40, sizeBackGround.height);
        }
        
        [self addSubview:_textLabel];
        
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        _textLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    });
}

- (void)initImage:(UIImage *)image message:(NSString *)str
{
    //内容视图
    if (iOS7Later)
    {
        [self setBackgroundColor:THEME_BLUE_COLOR];
        
    }else
    {
        [self setBackgroundColor:[UIColor blackColor]];
        
    }
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.message = str;
    self.timeOnScreen = 1.25;
    //添加图标
    //添加textLabel
    UIImageLabel *imageLabel = [[UIImageLabel alloc]initWithFrame:CGRectZero];
    imageLabel.padding = 5;
    imageLabel.imageName = @"meiyuan";
    imageLabel.textAlignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont systemFontOfSize:14];
    imageLabel.font = font;
    imageLabel.backgroundColor = [UIColor clearColor];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, IMAGE_STYLE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    imageLabel.frame = CGRectMake(0, 0, CGRectGetWidth(rect) + 30, IMAGE_STYLE_HEIGHT);
    
    [imageLabel setText:str];
    [self addSubview:imageLabel];
    
    if (imageLabel.frame.size.width > 280) {
        imageLabel.frame = CGRectMake(0, 0, CGRectGetWidth(rect) + 30, IMAGE_STYLE_HEIGHT);;
        self.frame = CGRectMake(0,0, 280, IMAGE_STYLE_HEIGHT);
    }else{
        
        self.frame = CGRectMake(0,0, imageLabel.frame.size.width + 20, IMAGE_STYLE_HEIGHT);
    }
    
    imageLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
}

- (id)initWithText:(NSString*)str theImage:(UIImage*)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 25);
        //内容视图
        if (iOS7Later)
        {
            [self setBackgroundColor:THEME_BLUE_COLOR];
            
        }else
        {
            [self setBackgroundColor:[UIColor blackColor]];
            
        }
        self.message = str;
        self.shouldHideOnTap = NO;
        self.manuallyHide = NO;
        self.timeOnScreen = 1;
        
        //添加textLabel
        UILabel *_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 0, CGRectGetWidth(self.frame)-39, CGRectGetHeight(self.frame))];
        self.textLabel = _textLabel;
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setFont:[UIFont systemFontOfSize:12]];
        [self.textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setText:str];
        [self addSubview:self.textLabel];
        //添加图标
        if (image&&![image isEqual:[NSNull null]]){
            UIImageView    *tipImage = [[UIImageView alloc]initWithImage:image];
            tipImage.frame = CGRectMake(19.5, 5, 10.5, 10);
            [self addSubview:tipImage];
        }
    }
    
    return self;
}

- (void)show
{
    UIWindow *window = kWindow;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    if (iOS7Later)
    {
        [window insertSubview:self atIndex:2];
        
    }else
    {
        [window insertSubview:self atIndex:0];
        
    }
    
    CGRect animationDestinationFrame;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        if (iOS7Later)
        {
            self.alpha = 1.0;
        }
        animationDestinationFrame = CGRectMake(0, 64 , [UIScreen mainScreen].bounds.size.width, 25);
    } else
    {
        animationDestinationFrame = CGRectMake(0, 64 - 20, [UIScreen mainScreen].bounds.size.height, 25);
    }
    
    [UIView animateWithDuration:.4
                     animations:^{
                         if (iOS7Later)
                         {
                             self.alpha = 1;
                         }
                         self.frame = animationDestinationFrame;
                     } completion:^(BOOL finished){
                         
                         
                         if (!self.manuallyHide) {
                             [NSTimer scheduledTimerWithTimeInterval:self.timeOnScreen
                                                              target:self
                                                            selector:@selector(hide)
                                                            userInfo:nil
                                                             repeats:NO];
                         }
                         
                     }];
    
}

- (void)hide
{
    if (self.isHidden) {
        return;
    }
    
    CGRect animationDestinationFrame;
    if (iOS6Later)
    {
        animationDestinationFrame = CGRectMake(0, 64 - 20, [UIScreen mainScreen].bounds.size.width, 25);
    } else
    {
        animationDestinationFrame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.height, 25);
    }
    
    [UIView animateWithDuration:.4
                     animations:^{
                         if (iOS7Later) {
                             self.alpha = 0;
                         }
                         self.frame = animationDestinationFrame;
                         //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                     } completion:^(BOOL finished){
                         if (finished) {
                             MAIN(^{
                                 [self removeFromSuperview];
                             });
                         }
                     }];
}

- (BOOL)isHidden
{
    return (self.superview == nil);
}

- (void)doTextScrollAnimation:(NSNumber*)timeInterval
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        __block CGRect frame = textLabel.frame;
        [UIView transitionWithView:textLabel
                          duration:timeInterval.floatValue
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            frame.origin.x = [UIScreen mainScreen].bounds.size.width - frame.size.width - frame.origin.x;
                            textLabel.frame = frame;
                        } completion:nil];
    } else {
        // add support for landscape
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.shouldHideOnTap == YES) {
        [self hide];
    }
}

- (void)showView
{
    UIWindow *window = kWindow;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    _bgView.frame = window.frame;
    _bgView.alpha = 1.0;
    
    MAIN(^{
        [window addSubview:_bgView];
        [window addSubview:self];
        
        self.alpha = 0.0;
        _bgView.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1.0;
            _bgView.alpha = 0.3;
        } completion:^(BOOL finished) {
            [self dismissView];
        }];
    });
    
    
}

- (void)dismissView
{
    [UIView animateWithDuration:0.25 delay:kTimeOnScreenDefault options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        MAIN(^{
            [_bgView removeFromSuperview];
            _bgView = nil;
            [self removeFromSuperview];
        });
    }];
}

- (void)show1
{
    UIWindow *window = kWindow;
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [window insertSubview:self atIndex:0];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        
        NSTimeInterval timeExceed = 0;
        [UIView animateWithDuration:.4 animations:^{
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25);
        } completion:^(BOOL finished){
            
            
            
            [self performSelector:@selector(doTextScrollAnimation:)
                       withObject:[NSNumber numberWithFloat:timeExceed]
                       afterDelay:ANIMATION_STATE_TIME/ 3];
            
            
        }];
    } else {
        // add support for landscape
    }
    
}



- (void)changeFrame
{
    [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^() {
        self.contentView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y , self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            //[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//初始化为默认状态

- (void)initializeToDefaultState
{
    //获取当前的状态栏位置
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    //设置当前视图的旋转, 根据当前设备的朝向
    
    [self rotateStatusBarWithFrame:[NSValue valueWithCGRect:statusBarFrame]];
}
//旋转屏幕

- (void)rotateStatusBarWithFrame:(NSValue *)frameValue
{
    CGRect frame = [frameValue CGRectValue];
    
    UIInterfaceOrientation orientation = STATUS_BAR_ORIENTATION;
    
    if (orientation == UIDeviceOrientationPortrait) {
        
        self.transform = CGAffineTransformIdentity; //屏幕不旋转
        
        [self setSubViewVFrame];
        
    }else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        self.transform = CGAffineTransformMakeRotation(M_PI); //屏幕旋转180度
        
        [self setSubViewVFrame];
        
    }else if (orientation == UIDeviceOrientationLandscapeRight) {
        
        self.transform = CGAffineTransformMakeRotation((M_PI * (-90.0f) / 180.0f)); //屏幕旋转-90度
        
        [self setSubViewHFrame];
        
    }else if (orientation == UIDeviceOrientationLandscapeLeft){
        
        self.transform = CGAffineTransformMakeRotation(M_PI * 90.0f / 180.0f); //屏幕旋转90度
        
        [self setSubViewHFrame];
    }
    self.frame = frame;
    [self.contentView setFrame:self.bounds];
}

//设置横屏的子视图的frame

- (void)setSubViewHFrame
{
    self.textLabel.frame = CGRectMake(30, 0, 1024-60, 25);
}

//设置竖屏的子视图的frame

- (void)setSubViewVFrame
{
    self.textLabel.frame = CGRectMake(30, 0, 320-60, 25);
}

#pragma mark -

#pragma mark 响应屏幕即将旋转时的事件响应

- (void)willRotateScreenEvent:(NSNotification *)notification
{
    NSValue *frameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    [self rotateStatusBarAnimatedWithFrame:frameValue];
}

- (void)rotateStatusBarAnimatedWithFrame:(NSValue *)frameValue {
    
    [UIView animateWithDuration:ROTATION_ANIMATION_DURATION animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self rotateStatusBarWithFrame:frameValue];
        
        [UIView animateWithDuration:ROTATION_ANIMATION_DURATION animations:^()
         {
             self.alpha = 1;
         }];
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _bgView = nil;
    textLabel = nil;
    contentView = nil;
}

@end
