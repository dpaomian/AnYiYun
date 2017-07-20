//
//  NSString+Extension.h
//  xuexin
//
//  Created by wxs on 16/6/13.
//  Copyright © 2016年 julong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (NSString *)MD5String;

- (NSUInteger)getBytesLength;

- (NSDictionary *)jsonDict;

- (NSString *)urlEncodedStringByStr;

#pragma mark - base64数据处理
//BASE64 Encoding
- (NSString *)base64Encoding;
//BASE64 Decoding
- (NSString *)base64Decoding;
//预案任务型消息单独base64解码
- (NSString *)anotherFunctionBase64Decoding;
//班级圈和活动 base64解码
- (NSString *)base64CircleDecoding;
/**过滤某一地址下所有文件，取图片类型*/
- (NSMutableArray *)filterAllImageFileType;
/**获取文件路径*/
- (NSString*)getFilePath:(NSString *)fileName;
@end
