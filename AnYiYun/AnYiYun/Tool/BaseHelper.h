//
//  BaseHelper.h
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseHelper : NSObject

#pragma mark - 字符串处理
/**空字符过滤<字典/数组/字符串/数字/NSNull>*/
+ (id)filterNullObj:(id)obj;

    //判断字符串为空使用替换值
+ (NSString *)isSpaceString:(NSString *)firstStr andReplace:(NSString *)replaceStr;

    //判定oldString字符串是否包含haveString字符串  不包含时拼接appendString字符串
+(NSString *)updateStringWithOldString:(NSString *)oldString isHaveString:(NSString *)haveString  andAppendString:(NSString *)appendString;

#pragma mark  - 字典字符串互转
    //字典转化为字符串
+ (NSString*)dictionaryToJson:(id)dic;
    //字符串转化为字典
+ (NSDictionary *)jsonToDictionary:(NSString *)str;

#pragma mark - 字体大小及字符串 宽 高计算
    //计算字符串宽度
+ (CGFloat)width:(NSString *)contentString heightOfFatherView:(CGFloat)height textFont:(UIFont *)font;
    //计算字符串高度
+ (CGFloat)height:(NSString *)contentString widthOfFatherView:(CGFloat)width textFont:(UIFont *)font;
    //计算带行间距字符串高度
+ (CGFloat)heightWithAttString:(NSString *)contentString widthLabelWidth:(CGFloat)width textFont:(UIFont *)font withNumberLine:(CGFloat)numberLine withMultiple:(CGFloat)multiple;
    //计算按钮的宽度 传入标题值 跟最大宽度
+(CGFloat)leftBtnWidth:(NSString *)contentString maxOfWidth:(CGFloat)maxWidth andFontSize:(CGFloat)fontSize;
#pragma mark - 其他
    //弹出框提示
+ (void)waringInfo:(NSString *)msgInfo;
    //接口请求追加固定参数
+ (NSDictionary *)dictionaryAppendDictionary:(NSDictionary *)param;

@end
