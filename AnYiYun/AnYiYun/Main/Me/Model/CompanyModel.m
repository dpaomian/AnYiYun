//
//  CompanyModel.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel


- (id)initWithDictionary:(NSDictionary *)userDictionary
{
    if (self = [super init])
        {
        _companyId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"id"] andReplace:@""];
        _companyName = [BaseHelper isSpaceString:[userDictionary valueForKey:@"name"] andReplace:@""];
        _companyLogoUrl = [BaseHelper isSpaceString:[userDictionary valueForKey:@"logoUrl"] andReplace:@""];
        }
    return self;
}

@end
