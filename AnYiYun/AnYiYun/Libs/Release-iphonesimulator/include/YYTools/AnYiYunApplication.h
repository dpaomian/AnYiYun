//
//  AnYiYunApplication.h
//  YYTools
//
//  Created by 韩亚周 on 17/8/3.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnYiYunApplication : NSObject

- (void)applicationInit:(void(^)(NSString *string))string;

+ (instancetype)applicationAlloc;

@end
