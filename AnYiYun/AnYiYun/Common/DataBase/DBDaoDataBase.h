//
//  DBDaoDataBase.h
//  xuexin
//
//  Created by 韩亚周 on 15/6/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
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
- (NSMutableArray *)getAllHistoryGroupInfo;
/**批量修改某类型消息 为已读状态*/
- (BOOL)updateHistoryGroupMessageNumWithType:(NSString *)type;
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
/*
 超过N条自动清理
 final String delSql = String.format("delete from %s where %s=? and %s=? and " +
 "(select count(%s) from %s where %s=? and %s=?)> ? and %s in " +
 "(select %s from %s where %s=? and %s=? order by %s asc limit " +
 "(select count(%s) from %s where %s=? and %s=?) offset ?)",
 TABLE, COLUM_USERID, COLUM_TYPE,
 COLUM_MESSAGEID, TABLE, COLUM_USERID, COLUM_TYPE, COLUM_MESSAGEID,
 COLUM_MESSAGEID, TABLE, COLUM_USERID, COLUM_TYPE, COLUM_CREATETIME,
 COLUM_MESSAGEID, TABLE, COLUM_USERID, COLUM_TYPE);
 
 超过dayNum天，清理
 final String delSql = String.format("delete from %s where %s=? and %s=? and " +
 "(select count(%s) from %s where %s=? and %s=? and %s < ?)> 0 " +
 "and %s < ?",
 TABLE, COLUM_USERID, COLUM_TYPE,
 COLUM_MESSAGEID, TABLE, COLUM_USERID, COLUM_TYPE, COLUM_CREATETIME,
 COLUM_CREATETIME);
 */



@end
