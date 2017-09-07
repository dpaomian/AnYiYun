//
//  ShareAppView.m
//  AnYiYun
//
//  Created by 韩亚周 on 29/7/17.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "ShareAppView.h"

#define kWindow  [UIApplication sharedApplication].keyWindow
#define column 4

@interface ShareAppView ()
{
    NSArray *shareTypeArr,*shareIconArr,*shareTitleArr;
    NSMutableArray *targetShareTypeArr,*targetshareIconArr,*targetshareTitleArr;
    /**需要隐藏的分享平台*/
    NSArray *noExitArr;
}
/**图层蒙版*/
@property (nonatomic,strong)  UIControl *overlayView;

/**取消button*/
@property (nonatomic, strong) UIButton *cancelButton;


@end

#define VIEWHEIGHT 160

@implementation ShareAppView

- (id)initWithFrame:(CGRect)frame WithItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = VIEWHEIGHT;
        self.backgroundColor = [UIColor whiteColor];
        noExitArr = items;
        /**分享平台数据源获取*/
        shareTypeArr = @[@0,@1];
        shareIconArr = @[@"message_icon.png",@"email_icon.png"];
        shareTitleArr = @[@"短信",@"邮件"];
        targetshareIconArr = [shareIconArr mutableCopy];
        targetshareTitleArr = [shareTitleArr mutableCopy];
        targetShareTypeArr = [shareTypeArr mutableCopy];
        [self getTargetSource];
        /**构建UI*/
        [self createUI];
    }
    return self;
}

#pragma mark - private methods
- (void)getTargetSource
{
    [shareTypeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([noExitArr containsObject:obj]) {
            NSInteger tag = [targetShareTypeArr indexOfObject:obj];
            [targetShareTypeArr removeObject:obj];
            [targetshareTitleArr removeObjectAtIndex:tag];
            [targetshareIconArr removeObjectAtIndex:tag];
        }
    }];
}

- (void)createUI
{
    CGSize iconSize = CGSizeMake(60, 60);
    CGFloat startX = 14;
    CGFloat startY = 10;
    CGFloat XMargin = 14;
    CGFloat YMargin = 0;
    
    int i_row,i_column;
    for (int i = 0; i<targetShareTypeArr.count; i++) {
        i_row = i/4;
        i_column = i%4;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        CGFloat x = startX + i_column * (iconSize.width  + XMargin);
        CGFloat y = startY + i_row * (iconSize.height + YMargin);
        button.frame = CGRectMake(x, y, iconSize.width, iconSize.height);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:[UIImage imageNamed:targetshareIconArr[i]] forState:UIControlStateNormal];
        button.tag = [targetShareTypeArr[i] integerValue];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
        [button addTarget:self action:@selector(clickShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        CGFloat height = [BaseHelper height:targetshareTitleArr[i] widthOfFatherView:iconSize.width textFont:[UIFont systemFontOfSize:12]];
        titleLabel.frame = CGRectMake(x, CGRectGetMaxY(button.frame) + 5, iconSize.width,height);
        titleLabel.text = targetshareTitleArr[i];
        titleLabel.textColor = RGBA(105, 105, 105,1);
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:button];
        [self addSubview:titleLabel];
    }
    [self addSubview:self.cancelButton];
}

#pragma mark - share delegate
- (void)ClickedCancelButtonInShareView
{
    [self dismissFromView];
}


#pragma public methods
- (void)showInView
{
    CGFloat innerWidth = CGRectGetWidth(self.frame);
    CGFloat innerHeight = CGRectGetHeight(self.frame);
    CGFloat innerX = CGRectGetMinX(self.frame);
    CGFloat innerTargetY = SCREEN_HEIGHT - innerHeight;
    CGFloat innerOriginalY = CGRectGetHeight(self.overlayView.frame);
    CGRect original = CGRectMake(innerX, innerOriginalY, innerWidth, innerHeight);
    CGRect target = CGRectMake(innerX, innerTargetY, innerWidth, innerHeight);
    [self setFrame:original];
    [kWindow addSubview:self.overlayView];
    [kWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setFrame:target];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)dismissFromView
{
    CGFloat innerWidth = CGRectGetWidth(self.frame);
    CGFloat innerHeight = CGRectGetHeight(self.frame);
    CGFloat innerX = CGRectGetMinX(self.frame);
    CGFloat innerOriginalY = SCREEN_HEIGHT;
    
    CGRect original = CGRectMake(innerX, innerOriginalY, innerWidth, innerHeight);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setFrame:original];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.overlayView removeFromSuperview];
    }];
}

#pragma mark - setter/getter
- (void)setShareUrl:(NSString *)shareUrl
{
    _shareUrl = shareUrl;
}

- (void)setShareTitle:(NSString *)shareTitle
{
    _shareTitle = shareTitle;
}

- (void)dealloc
{
    
    self.cancelButton = nil;
    self.overlayView = nil;
}

#pragma mark - ActionMethods

- (void)clickShareButtonAction:(UIButton *)sender
{
    [self dismissFromView];
    
   NSString *string =  shareTitleArr[sender.tag];
   self.shareBlock(string);
}

- (void)cancelAction
{
    [self dismissFromView];
}

- (void)dismissCurrentView
{
    [self dismissFromView];
}
#pragma mark - setter/getter

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, VIEWHEIGHT - 44, self.frame.size.width, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        [_cancelButton setBackgroundColor:RGBA(244, 244, 244,1)];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


- (UIControl *)overlayView
{
    if(!_overlayView){
        _overlayView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [_overlayView addTarget:self action:@selector(dismissCurrentView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayView;
}


@end
