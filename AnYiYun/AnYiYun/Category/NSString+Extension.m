//
//  NSString+Extension.m
//  xuexin
//
//  Created by wxs on 16/6/13.
//  Copyright © 2016年 julong. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>

@implementation NSString (Extension)

static char MXSKitStringJsonDictionaryAddress;

- (CGSize)stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    if ([self isKindOfClass:[NSNull class]]) {
        return CGSizeZero;
    }
    NSDictionary *AttriButes = @{NSFontAttributeName:font};
    CGSize contentSize = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                            options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:AttriButes
                                            context:nil].size;
    return contentSize;
}

- (NSString *)MD5String
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}

- (NSDictionary *)jsonDict
{
    NSDictionary *dict = [objc_getAssociatedObject(self, &MXSKitStringJsonDictionaryAddress) copy];
    if (dict == nil)    //解析过一次后就缓存解析结果，避免多次解析
    {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:nil];
        if (![dict isKindOfClass:[NSDictionary class]])
        {
            dict = [NSDictionary dictionary];
        }
        objc_setAssociatedObject(self,&MXSKitStringJsonDictionaryAddress,dict,OBJC_ASSOCIATION_COPY);
    }
    return dict;
}

- (NSString *)urlEncodedStringByStr
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}
#pragma mark - base64数据处理
//BASE64 Encoding
- (NSString *)base64Encoding
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

//BASE64 Decoding
- (NSString *)base64Decoding
{
    NSString *myBase64Str = [BaseHelper isSpaceString:self andReplace:@""];//判断不为空
    myBase64Str = [myBase64Str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    myBase64Str = [myBase64Str stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:myBase64Str options:0];
    NSString *resultString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSString *decodedStr = [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //兼容oa(\r) od（\n）
    decodedStr = [decodedStr stringByReplacingOccurrencesOfString:@"\r\n"withString:@"<br>"];
    decodedStr = [decodedStr stringByReplacingOccurrencesOfString:@"\n"withString:@"<br>"];
    decodedStr = [decodedStr stringByReplacingOccurrencesOfString:@"\\n"withString:@"<br>"];
    //decodedString = [decodedString stringByReplacingOccurrencesOfString:@" "withString:@"&nbsp;"];
    return decodedStr;
}

//预案任务型消息单独base64解码
- (NSString *)anotherFunctionBase64Decoding
{
   NSString *myBase64String = [self stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    myBase64String = [myBase64String stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:myBase64String options:0];
    NSString *resultString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return resultString;
}

//班级圈和活动 base64解码
- (NSString *)base64CircleDecoding
{
    NSString *myBase64Str = [self stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    myBase64Str = [myBase64Str stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:myBase64Str options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"+"withString:@"%20"];
    
    //二次编码
    NSString *usedeCodeString = [decodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([BaseHelper isSpaceString:usedeCodeString andReplace:@""].length>0)
    {
        decodedString = usedeCodeString;
    }
    return decodedString;
}


- (NSMutableArray *)filterAllImageFileType
{
    NSArray *localImageFiles = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self error:nil];
    NSMutableArray *allImages = [[NSMutableArray alloc] initWithCapacity:10];
    [localImageFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *suffixNameStr = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([suffixNameStr isEqualToString:@"jpg"] || [suffixNameStr isEqualToString:@"JPG"] || [suffixNameStr isEqualToString:@"png"] || [suffixNameStr isEqualToString:@"PNG"]) {
            [allImages addObject:obj];
        }
    }];
    
    return allImages;
}
/**  eg：
 *   NSString *cacheFilePath = [PATH_AT_CACHEDIR(kUserCacheChatVideoFolder) getFilePath:[videoUrlString componentsSeparatedByString:@"/"].lastObject];
 *
 */
- (NSString*)getFilePath:(NSString *)fileName
{
    NSString *finalPath = [self stringByAppendingPathComponent:fileName];
    return finalPath;
    
}



@end
