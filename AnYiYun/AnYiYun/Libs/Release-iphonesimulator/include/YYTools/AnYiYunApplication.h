//
//  AnYiYunApplication.h
//  YYTools
//
//  Created by 韩亚周 on 17/8/3.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnYiYunApplication : NSObject

- (void)applicationInit:(void(^)(NSString *string))string;

+ (instancetype)applicationAlloc;

@end
