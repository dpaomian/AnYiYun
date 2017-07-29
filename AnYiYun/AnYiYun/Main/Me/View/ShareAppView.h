//
//  ShareAppView.h
//  AnYiYun
//
//  Created by wuwanru on 29/7/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareAppView : UIView

@property (nonatomic, strong) NSString *shareTitle;

@property (nonatomic, strong) NSString *shareUrl;

@property (nonatomic, copy) void (^shareBlock)(NSString *nameString);
- (void)showInView;
- (void)dismissFromView;
- (id)initWithFrame:(CGRect)frame WithItems:(NSArray *)items;

@end
