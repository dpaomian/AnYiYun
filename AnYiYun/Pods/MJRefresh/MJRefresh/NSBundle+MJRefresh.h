//
//  NSBundle+MJRefresh.h
//  MJRefreshExample
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (MJRefresh)
+ (instancetype)mj_refreshBundle;
+ (UIImage *)mj_arrowImage;
+ (NSString *)mj_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)mj_localizedStringForKey:(NSString *)key;
@end
