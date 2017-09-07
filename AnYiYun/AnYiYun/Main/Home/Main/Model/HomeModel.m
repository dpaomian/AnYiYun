//
//  HomeModel.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/21.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "HomeModel.h"


@implementation HomeModel


@end

@implementation HomeAdverModel

- (id)initWithDictionary:(NSDictionary *)userDictionary
{
    if (self = [super init])
        {
        _adverId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"id"] andReplace:@""];
        _companyId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"companyId"] andReplace:@""];
        _name = [BaseHelper isSpaceString:[userDictionary valueForKey:@"name"] andReplace:@""];
        _pic_url = [BaseHelper isSpaceString:[userDictionary valueForKey:@"pic_url"] andReplace:@""];
        _url = [BaseHelper isSpaceString:[userDictionary valueForKey:@"url"] andReplace:@""];
        _delFlag = [[userDictionary valueForKey:@"delFlag"] boolValue];
        }
    return self;
}

@end


@implementation HomeModuleModel


@end
