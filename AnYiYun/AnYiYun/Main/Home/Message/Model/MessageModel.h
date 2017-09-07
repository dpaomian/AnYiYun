//
//  MessageModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,strong) NSString *messageId;
@property (nonatomic,strong) NSString  *messageTitle;
@property (nonatomic,strong) NSString  *messageContent;
@property (nonatomic,assign) NSInteger  ctime;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *result;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *pointId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userName;

    //数据库补充字段
    //103待检修 104待保养
@property (nonatomic,strong)NSString *type;
    //消息是否已读 0未读 1已读
@property (nonatomic,strong)NSString *isRead;
@property (nonatomic,assign)long long uploadtime;
@property (nonatomic,strong)NSString *remark;

- (id)initWithDictionary:(NSDictionary *)userDictionary;


@end


@interface HistoryMessageModel : NSObject

@property (nonatomic,assign)NSInteger historyMessageId;
//（消息类型（101报警，102报警，103待检修，104待保养，105系统公告））
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *typeName;
@property (nonatomic,strong)NSString *iconUrl;
@property (nonatomic,strong)NSString *recentMes;
@property (nonatomic,assign)NSInteger rtime;
@property (nonatomic,assign)NSInteger num;

- (id)initWithDictionary:(NSDictionary *)userDictionary;

@end

