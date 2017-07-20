//
//  UIColor+Extension.h
//  BaseProject
//
//  Created by wwr on 16/11/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(Extension)

// 将16进制字符串转换成UIColor
- (UIColor *)toUIColorByStr:(NSString*)colorStr;

/**颜色转换 IOS中十六进制的颜色转换为UIColor*/
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
