//
//  CompanyModel.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FilterCompanyModel.h"

@implementation FilterCompanyModel

+ (instancetype)shareModel {
    static FilterCompanyModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end