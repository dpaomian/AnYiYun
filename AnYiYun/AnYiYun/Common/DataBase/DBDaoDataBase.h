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

#pragma mark - 消息分组记录表 T_HistoryMessageGroup_TABLE
/**创建消息分组记录表*/
- (BOOL)createHistoryMessageGroupTable;
/**添加消息分组历史记录*/
- (void)addHistoryMessageGroupInfoTableClassify:(HistoryMessageModel *)adModel;
/**根据消息id获取消息*/
- (HistoryMessageModel *)getHistoryMessagesGroupInfoWithType:(NSString *)type;

#pragma mark - 消息历史记录表
/**创建消息历史记录表*/
- (BOOL)createHistoryMessageTable;

/**添加消息历史记录*/
- (void)addHistoryMessageInfoTableClassify:(MessageModel *)adModel;

    //是否包含未读消息
- (NSInteger)getAllUnreadHistoryMessagesCount;

/**获取消息历史记录表中的不同类型的数据*/
- (NSMutableArray *)getAllHistoryMessagesInfoWithType:(NSString *)type;

//删除消息不同类型的历史记录数据
- (BOOL)deleteHistoryMessagesWithType:(NSString *)type;

/**批量修改某类型消息 为已读状态*/
- (BOOL)updateHistoryMessageReadStatusWithType:(NSString *)type;


@end
