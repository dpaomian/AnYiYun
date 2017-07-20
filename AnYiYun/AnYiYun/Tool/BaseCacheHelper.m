//
//  BaseCacheHelper.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseCacheHelper.h"

@implementation BaseCacheHelper

+ (void)releaseAllCache
{
    [PersonInfo shareInstance].password = @"";
    
    [BaseCacheHelper setPersonInfo];
    
    [[TMCache sharedCache] removeAllObjects];
}

+ (void)setPersonInfo
{
    PersonInfo *personInfo = [PersonInfo shareInstance];
    [self setValue:personInfo.mj_keyValues forKey:kPersonInfo];
}

+ (void)getPersonInfo
{
    NSDictionary *dic = [self valueForKey:kPersonInfo];
    if (dic.allKeys.count >0) {
        [[PersonInfo shareInstance] initWithCacheDic:dic];
    }
}

    //为特定key指定value
+ (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    //从特定key取得value
+ (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

    //为特定key指定value
+ (void)setBOOLValue:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    //从特定key取得value
+ (BOOL)getBOOLValueForKey:(NSString *)key
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:key] boolValue];
}

/**
 *  缓存文件处理
 *
 */
    //从某文件中移除内容
+ (void)removeContentsOfFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:NULL];
    }
}
    //创建文件目录
+ (BOOL)createFolder:(NSString*)folderPath isDirectory:(BOOL)isDirectory {
    NSString *path = nil;
    if(isDirectory) {
        path = folderPath;
    } else {
        path = [folderPath stringByDeletingLastPathComponent];
    }
        //文件夹不存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
        NSError *error = nil;
        BOOL ret;
        
        ret = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&error];
        if(!ret && error) {
            DLog(@"create folder failed at path '%@',error:%@,%@",folderPath,[error localizedDescription],[error localizedFailureReason]);
            return NO;
        }
        return YES;
        }
    return YES;
}

#pragma mark - TMCache 缓存
    //TMCache 缓存
+ (void)tmcacheSetObject:(id)object forKey:(NSString *)key
{
    [[TMCache sharedCache] setObject:object forKey:key];
}

    //TMCache 获取缓存
+ (void)tmcacheGetObjectForKey:(NSString *)key block:(TMCacheObjectBlock)block
{
    [[TMCache sharedCache] objectForKey:key block:^(TMCache *cache, NSString *key, id object) {
        block(cache,key,object);
    }];
}


@end
