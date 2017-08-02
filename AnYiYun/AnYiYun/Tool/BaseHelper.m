//
//  BaseHelper.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseHelper.h"

@implementation BaseHelper

#pragma mark - 字符串处理
+ (id)filterNullObj:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]])
        {
        return [self nullDic:obj];
        }
    else if([obj isKindOfClass:[NSArray class]])
        {
        return [self nullArr:obj];
        }
    else if([obj isKindOfClass:[NSString class]])
        {
        return [self stringToString:obj];
        }
    else if([obj isKindOfClass:[NSNull class]])
        {
        return [self nullToString];
        }
    else if ([obj isKindOfClass:[NSNumber class]])
        {
        return [self numberToString:obj];
        }
    else if (obj == nil){
        return @"";
    }
    else
        {
        return obj;
        }
    
}

+ (NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
        {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self filterNullObj:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
        }
    return resDic;
}

+ (NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
        {
        id obj = myArr[i];
        
        obj = [self filterNullObj:obj];
        
        [resArr addObject:obj];
        }
    return resArr;
}

+ (NSString *)stringToString:(NSString *)string
{
    return [NSString stringWithFormat:@"%@",string];
}

+ (NSString *)nullToString
{
    return @"";
}

+ (NSString *)numberToString:(NSNumber *)number
{
    return [NSString stringWithFormat:@"%@",number];
}

    //判断字符串为空使用替换值
+ (NSString *)isSpaceString:(NSString *)firstStr andReplace:(NSString *)replaceStr
{
    if ([firstStr isKindOfClass:[NSNull class]]||(![firstStr isKindOfClass:[NSNumber class]] && [firstStr isEqualToString:@"(null)"]) || firstStr == nil || (([firstStr isKindOfClass:[NSString class]] && firstStr.length == 0) || ([firstStr isKindOfClass:[NSNumber class]] && firstStr == nil)))
        {
        return replaceStr;
        }
    else if ([firstStr isKindOfClass:[NSNumber class]] && firstStr != nil)
        {
        return [NSString stringWithFormat:@"%@", firstStr];
        }
    else
        {
        firstStr = [firstStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        
        if ([firstStr isEqualToString:@""])
            {
            return replaceStr;
            }
        else
            return firstStr;
        }
}

    //判定oldString字符串是否包含haveString字符串  不包含时拼接appendString字符串
+(NSString *)updateStringWithOldString:(NSString *)oldString isHaveString:(NSString *)haveString  andAppendString:(NSString *)appendString
{
    NSString  *resultString = oldString;
    if ([oldString rangeOfString:haveString].location==NSNotFound)
        {
        resultString = [NSString stringWithFormat:@"%@%@",oldString,appendString];
        }
    return resultString;
}

#pragma mark  - 字典字符串互转
    //字典转化为字符串
+ (NSString*)dictionaryToJson:(id)dic
{
    if (dic!=nil)
        {
        NSError *parseError = nil;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    return @"";
    
}
    //字符串转化为字典
+ (NSDictionary *)jsonToDictionary:(NSString *)str
{
    if (str!=nil)
        {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        return dic;
        }
    return nil;
}


#pragma mark - 字体大小及字符串 宽 高计算

    //计算字符串宽度；
+ (CGFloat)width:(NSString *)contentString heightOfFatherView:(CGFloat)height textFont:(UIFont *)font{
    contentString = [self isSpaceString:contentString andReplace:@""];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    CGSize size = [contentString sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)];
    return size.width ;
#else
    NSDictionary *attributesDic = @{NSFontAttributeName:font};
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    return size.width;
#endif
}
    //计算字符串高度
+ (CGFloat)height:(NSString *)contentString widthOfFatherView:(CGFloat)width textFont:(UIFont *)font{
    contentString = [self isSpaceString:contentString andReplace:@""];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    CGSize size = [contentString sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
#else
    NSDictionary *attributesDic = @{NSFontAttributeName:font};
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    return size.height;
#endif
}


    //计算带行间距字符串高度
+ (CGFloat)heightWithAttString:(NSString *)contentString widthLabelWidth:(CGFloat)width textFont:(UIFont *)font withNumberLine:(CGFloat)numberLine withMultiple:(CGFloat)multiple
{
    contentString = [self isSpaceString:contentString andReplace:@""];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
    lable.numberOfLines = numberLine;
    lable.font = font;
    lable.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineHeightMultiple = multiple;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:@{NSParagraphStyleAttributeName:style}];
    [lable setAttributedText:attributedString];
    
    CGFloat height = [lable sizeThatFits:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-20.0f, MAXFLOAT)].height;
    
        //DLog(@"%f",height);
    
    return height;
    
}

    //计算按钮的宽度 传入标题值 跟最大宽度
+(CGFloat)leftBtnWidth:(NSString *)contentString maxOfWidth:(CGFloat)maxWidth andFontSize:(CGFloat)fontSize
{
    if (maxWidth>SCREEN_WIDTH-20)
        {
        maxWidth=SCREEN_WIDTH-20;
        }
    CGFloat widthUse = [self width:contentString heightOfFatherView:30 textFont:[UIFont systemFontOfSize:fontSize]];
    if (widthUse>maxWidth)
        {
        widthUse = maxWidth;
        }
    return widthUse;
}

#pragma mark - 文件操作
    //通常用于删除缓存的时，计算缓存大小
    //单个文件的大小
+ (long long)getFileSizeAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
    //遍历文件夹获得文件夹大小，返回多少M
+ (float )getFolderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self getFileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


#pragma mark - 其他
    //弹出框提示
+ (void)waringInfo:(NSString *)msgInfo
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                  message:msgInfo
                                                 delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                        otherButtonTitles:nil,nil];
    [alert show];
}

    //接口请求追加固定参数
+ (NSDictionary *)dictionaryAppendDictionary:(NSDictionary *)param
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    [dic setValue:[BaseHelper isSpaceString:[PersonInfo shareInstance].accountID andReplace:@""] forKey:@"userSign"];
    return dic;
}

/**获取当前手机时间 毫秒值*/
+ (long long)getSystemNowTimeLong
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    long long date = (long long )time;
    return date;
}

/*!计算当前用户使用时间，传进来创建时的时间戳*/
+ (NSString *)getUserTimeStringWith:(NSString *)timeStamp {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000];
    NSDate *today = [NSDate date];//当前时间
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [calendar components:unitFlags fromDate:createDate toDate:today options:0];
    /**
    if ([d day] <= 0 &&
        [d hour] <= 0 &&
        [d minute] <= 0 &&
        [d second] <= 0) {
            return  @"00天00小时00分00秒";
    }else{
        return [NSString stringWithFormat:@"%.2li天%.2li小时%.2li分%.2li秒", [d day], [d hour], [d minute], [d second]];
    }
    */
    
    if ([d day] <= 0 &&
        [d hour] <= 0 &&
        [d minute] <= 0 &&
        [d second] <= 0) {
        return  @"00天00小时00分";
    }else{
        return [NSString stringWithFormat:@"%.2li天%.2li小时%.2li分", [d day], [d hour], [d minute]];
    }
}

@end
