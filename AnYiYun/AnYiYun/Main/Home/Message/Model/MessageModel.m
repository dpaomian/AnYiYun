//
//  MessageModel.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"id": @"messageId",
             @"title":@"messageTitle",
             @"content":@"messageContent"
             };
}



- (id)initWithDictionary:(NSDictionary *)userDictionary
{
    if (self = [super init])
        {
        _messageId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"id"] andReplace:@""];
        _messageTitle = [BaseHelper isSpaceString:[userDictionary valueForKey:@"title"] andReplace:@""];
        
        _messageContent = [BaseHelper isSpaceString:[userDictionary valueForKey:@"content"] andReplace:@""];

        _time = [BaseHelper isSpaceString:[userDictionary valueForKey:@"time"] andReplace:@""];
        _result = [BaseHelper isSpaceString:[userDictionary valueForKey:@"result"] andReplace:@""];
        _deviceId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"deviceId"] andReplace:@""];
        _pointId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"pointId"] andReplace:@""];
        
        _userId = [BaseHelper isSpaceString:[userDictionary valueForKey:@"userId"] andReplace:@""];
        _userName = [BaseHelper isSpaceString:[userDictionary valueForKey:@"userName"] andReplace:@""];
        _ctime = [[BaseHelper isSpaceString:[userDictionary valueForKey:@"ctime"] andReplace:@""]integerValue];
        _state = [[BaseHelper isSpaceString:[userDictionary valueForKey:@"state"] andReplace:@""]integerValue];//分值
        }
    return self;
}


@end



@implementation HistoryMessageModel

- (id)initWithDictionary:(NSDictionary *)userDictionary
{
    if (self = [super init])
    {
        _historyMessageId = [[BaseHelper isSpaceString:[userDictionary valueForKey:@"id"] andReplace:@""] integerValue];
        _type = [[BaseHelper isSpaceString:[userDictionary valueForKey:@"type"] andReplace:@""] integerValue];
        
        _typeName = [BaseHelper isSpaceString:[userDictionary valueForKey:@"typeName"] andReplace:@""];
        _iconUrl = [BaseHelper isSpaceString:[userDictionary valueForKey:@"iconUrl"] andReplace:@""];
        _recentMes = [BaseHelper isSpaceString:[userDictionary valueForKey:@"recentMes"] andReplace:@""];
        
        _rtime = [[BaseHelper isSpaceString:[userDictionary valueForKey:@"rtime"] andReplace:@""] integerValue];
        _num = [[BaseHelper isSpaceString:[userDictionary valueForKey:@"num"] andReplace:@""] integerValue];
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"id": @"historyMessageId"
             };
}

@end
