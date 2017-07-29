//
//  DBDaoDataBase.h
//  xuexin
//
//  Created by mac on 15/6/19.
//  Copyright (c) 2015年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

//多线程支持
@interface DBDaoDataBase : NSObject

+ (DBDaoDataBase *)sharedDataBase;
+ (void)releaseDatabase;

#pragma mark - 消息历史记录表
/**创建消息历史记录表*/
- (BOOL)createHistoryMessageTable;

/**添加消息历史记录*/
- (void)addHistoryMessageInfoTableClassify:(MessageModel *)adModel;

/**查询是否有未读消息 传空 查询全部 1待检修 2待保养*/
- (BOOL)isHaveNoReadHistoryMessageWithType:(NSString *)type;

/**删除单条消息历史记录*/
- (BOOL)deleteHistoryMessageInfo:(NSString *)pidString;

/**根据消息id获取消息*/
- (MessageModel *)getHistoryMessagesInfoWithMessageId:(NSString *)messageId;

/**获取消息历史记录表中的所有数据*/
- (NSMutableArray *)getAllHistoryMessagesInfo;

/**获取消息历史记录表中的不同类型的数据*/
- (NSMutableArray *)getAllHistoryMessagesInfoWithType:(NSString *)type;

//删除消息不同类型的历史记录数据
- (BOOL)deleteHistoryMessagesWithType:(NSString *)type;

    //删除消息历史记录数据
- (BOOL)deleteAllHistoryMessages;

@end
