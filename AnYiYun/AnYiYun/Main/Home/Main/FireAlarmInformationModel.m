//
//  FireAlarmInformationModel.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "FireAlarmInformationModel.h"

@implementation FireAlarmInformationModel

- (MessageModel *)conversionToMessModelWith:(FireAlarmInformationModel *)model {
    MessageModel *message = [[MessageModel alloc] init];
    message.messageId = model.idF;
    message.messageTitle = model.title;
    message.messageContent = model.content;
    message.ctime = [model.ctime integerValue];
    message.time = model.time;
    message.result = @"";
    message.state = [model.state integerValue];
    message.deviceId = model.deviceId;
    message.pointId = @"";
    message.userId = @"";
    message.userName = @"";
    message.type = @"103";
    message.isRead = @"0";
    message.uploadtime = [BaseHelper getSystemNowTimeLong];
    message.remark = @"";
    return message;
}

@end
