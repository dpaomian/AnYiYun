//
//  UIResponder+FirstResponder.m
//  xuexin
//
//  Created by 韩亚周 on 16/6/13.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;
static __weak id currentSecodResponder;

@implementation UIResponder (FirstResponder)

+ (instancetype)currentFirstResponder {
    currentFirstResponder = nil;
    currentSecodResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

+ (instancetype)currentSecondResponder{
    currentFirstResponder = nil;
    currentSecodResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentSecodResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
    [self.nextResponder findSecondResponder:sender];
}


- (void)findSecondResponder:(id)sender{
    currentSecodResponder = self;
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}


@end
