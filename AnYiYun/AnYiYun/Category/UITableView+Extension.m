//
//  UITableView+ScrollToBottom.m
//  xuexin
//
//  Created by wxs on 16/6/13.
//  Copyright © 2016年 julong. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)scrollToBottom:(BOOL)animation
{
    if (self.contentSize.height + self.contentInset.top > self.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
        [self setContentOffset:offset animated:animation];
    }

}

- (void)hiddenExtraCellLine
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    [self setTableHeaderView:view];
}

@end
