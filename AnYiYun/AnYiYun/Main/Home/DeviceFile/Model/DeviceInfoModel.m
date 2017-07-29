//
//  DeviceInfoModel.m
//  AnYiYun
//
//  Created by wuwanru on 29/7/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "DeviceInfoModel.h"

@implementation DeviceInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"id": @"deviceId",
             @"description":@"device_description"
             };
}

@end


@implementation DeviceDocModel

@end

@implementation DevicePartModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"id": @"partId"
             };
}

@end

