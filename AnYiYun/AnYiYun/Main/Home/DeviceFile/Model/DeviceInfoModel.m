//
//  DeviceInfoModel.m
//  AnYiYun
//
//  Created by 韩亚周 on 29/7/17.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
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

