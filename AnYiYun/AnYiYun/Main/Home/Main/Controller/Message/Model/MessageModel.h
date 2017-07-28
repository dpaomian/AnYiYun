//
//  MessageModel.h
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,assign) NSInteger messageId;
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
    //1告警报修 2待保养
@property (nonatomic,strong)NSString *type;
    //消息是否已读 0未读 1已读
@property (nonatomic,strong)NSString *isRead;
@property (nonatomic,assign)long long uploadtime;
@property (nonatomic,strong)NSString *remark;

- (id)initWithDictionary:(NSDictionary *)userDictionary;


@end


@interface HistoryMessageModel : NSObject

@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *typeTitle;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *content;

@end

