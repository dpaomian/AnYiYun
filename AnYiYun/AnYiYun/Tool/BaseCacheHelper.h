//
//  BaseCacheHelper.h
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonInfo.h"
#import "TMCache.h"

#define kFirstApp @"kFirsAapp"
#define kPersonInfo @"kPersonInfo"

/**
 *  缓存类
 */
@interface BaseCacheHelper : NSObject

+ (void)releaseAllCache;

+ (void)setPersonInfo;

+ (void)getPersonInfo;

    //NSUserDefaults数据存取处理
+ (void)setValue:(id)value forKey:(NSString *)key;
+ (id)valueForKey:(NSString *)key;

    //为特定key指定value
+ (void)setBOOLValue:(BOOL)value forKey:(NSString *)key;

+ (BOOL)getBOOLValueForKey:(NSString *)key;

    //缓存文件处理
+ (void)removeContentsOfFilePath:(NSString *)filePath;//从某文件中移除内容
+ (BOOL)createFolder:(NSString*)folderPath isDirectory:(BOOL)isDirectory;//创建文件目录

#pragma mark - TMCache 缓存
    //TMCache 缓存
+ (void)tmcacheSetObject:(id)object forKey:(NSString *)key;

    //TMCache 获取缓存
+ (void)tmcacheGetObjectForKey:(NSString *)key block:(TMCacheObjectBlock)block;

@end
