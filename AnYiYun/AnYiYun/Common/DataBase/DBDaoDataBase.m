//
//  DBDaoDataBase.m
//  xuexin
//
//  Created by 韩亚周 on 15/6/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "DBDaoDataBase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

static DBDaoDataBase *_instance;

@interface DBDaoDataBase ()
{
    FMDatabaseQueue *_dbQueue;
}
@end

@implementation DBDaoDataBase

    //返回实例
+ (DBDaoDataBase *)sharedDataBase
{
    if(_instance == nil)
        {
        _instance = [[DBDaoDataBase alloc] init];
        }
    
    return _instance;
}
    //释放实例
+ (void)releaseDatabase
{
    if (_instance)
        {
        _instance = nil;
        }
}
    //进行初始化
- (id)init
{
    self = [super init];
    if(!self) return nil;
    
    NSString *userCode = [PersonInfo shareInstance].accountID;
    if ([userCode length] != 0)
        {
        NSString *dbName = [NSString stringWithFormat:@"%@/DBDatabase.sqlite",userCode];
        NSString *dbPath = PATH_AT_CACHEDIR(dbName);
        DLog(@"DB地址：%@",dbPath);
        
        BOOL isCreate =  [BaseCacheHelper createFolder:dbPath isDirectory:NO];
        if (isCreate)
            {
            DLog(@"数据库创建查找成功 路径=%@",dbPath);
            _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
            [_dbQueue inDatabase:^(FMDatabase *db)
             {
             if(![db open])
                 {
                 DLog(@"open database failed at '%@'",[db databasePath]);
                 }
             }];
            
                //初始化进行数据库表的创建
            if(!([self createHistoryMessageTable]&&[self createHistoryMessageGroupTable]))
                {
                return nil;
                }
            return self;
            }
        }
    return nil;
}

#pragma mark - 消息分组记录表 T_HistoryMessageGroup_TABLE
/**创建消息分组记录表*/
- (BOOL)createHistoryMessageGroupTable
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *sql = @"CREATE TABLE IF NOT EXISTS T_HistoryMessageGroup_TABLE(historyMessageId    integer not null primary key,\
         type  integer not null,\
         typeName TEXT,\
         iconUrl TEXT,\
         rtime  integer not null,\
         recentMes TEXT,\
         num integer not null,\
         remark TEXT)";
         success = [db executeUpdate:sql];
         if(!success)
         {
             DLog(@"create T_HistoryMessageGroup_TABLE  table failed,error:%@",[db lastErrorMessage]);
         }
         [db close];
     }];
    return success;
}

/**添加消息分组历史记录*/
- (void)addHistoryMessageGroupInfoTableClassify:(HistoryMessageModel *)adModel
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *addSqlString = [NSString stringWithFormat:@"insert or replace into T_HistoryMessageGroup_TABLE (historyMessageId, type, typeName,iconUrl,rtime,recentMes,num,remark) values ('%ld', '%ld', '%@', '%@', '%ld','%@', '%ld', '%@')", (long)adModel.historyMessageId, (long)adModel.type, adModel.typeName, adModel.iconUrl, (long)adModel.rtime, adModel.recentMes, (long)adModel.num, @""];
         success = [db executeUpdate:addSqlString];
         if (success)
         {
             DLog(@"insert into T_HistoryMessageGroup_TABLE success");
         }
         else
         {
             DLog(@"insert into T_HistoryMessageGroup_TABLE failed, error:%@",[db lastErrorMessage]);
         }
         [db close];
     }];
    
}

/**获取消息历史记录表中的不同类型的数据*/
- (NSMutableArray *)getAllHistoryGroupInfo
{
    __block  NSMutableArray *mutable = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *findSqlString = [NSString stringWithFormat:@"select * from T_HistoryMessageGroup_TABLE"];
     FMResultSet *rs = [db executeQuery:findSqlString];
     while (rs && [rs next])
         {
         HistoryMessageModel *adObject = [[HistoryMessageModel alloc] init];
         adObject.historyMessageId = [rs longForColumn:@"historyMessageId"];
         adObject.type = [rs longForColumn:@"type"];
         adObject.typeName = [rs stringForColumn:@"typeName"];
         adObject.iconUrl = [rs stringForColumn:@"iconUrl"];
         adObject.rtime = [rs longForColumn:@"rtime"];
         adObject.recentMes = [rs stringForColumn:@"recentMes"];
         adObject.num = [rs longForColumn:@"num"];
         [mutable addObject:adObject];
         }
     [db close];
     }];
    return mutable;
    
}

/**根据消息id获取消息*/
- (HistoryMessageModel *)getHistoryMessagesGroupInfoWithType:(NSString *)type
{
    __block  HistoryMessageModel *useObject = [[HistoryMessageModel alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *findSqlString = [NSString stringWithFormat:@"select * from T_HistoryMessageGroup_TABLE WHERE type= %ld",[type integerValue]];
         FMResultSet *rs = [db executeQuery:findSqlString];
         while (rs && [rs next])
         {
             HistoryMessageModel *adObject = [[HistoryMessageModel alloc] init];
             adObject.historyMessageId = [rs longForColumn:@"historyMessageId"];
             adObject.type = [rs longForColumn:@"type"];
             adObject.typeName = [rs stringForColumn:@"typeName"];
             adObject.iconUrl = [rs stringForColumn:@"iconUrl"];
             adObject.rtime = [rs longForColumn:@"rtime"];
             adObject.recentMes = [rs stringForColumn:@"recentMes"];
             adObject.num = [rs longForColumn:@"num"];
             useObject = adObject;
         }
         [db close];
     }];
    return useObject;
    
}

/**批量修改某类型消息 为已读状态*/
- (BOOL)updateHistoryGroupMessageNumWithType:(NSString *)type
{
    __block BOOL success = NO;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sqlString3 = [NSString stringWithFormat:@"update T_HistoryMessageGroup_TABLE set num = %d where type = %ld ", 0 ,[type integerValue]];
     success = [db executeUpdate:sqlString3];
     [db close];
     }];
    return success;
}

#pragma mark - 消息历史记录表 T_HistoryMessage_TABLE
/**创建消息历史记录表*/
- (BOOL)createHistoryMessageTable
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sql = @"CREATE TABLE IF NOT EXISTS T_HistoryMessage_TABLE(messageId    TEXT primary key,\
     messageTitle   TEXT,\
     messageContent TEXT,\
     ctime  integer not null,\
     time TEXT,\
     result TEXT,\
     state  integer not null,\
     deviceId TEXT,\
     pointId TEXT,\
     userId TEXT,\
     userName TEXT,\
     type TEXT,\
     isRead TEXT,\
     uploadtime integer not null,\
     remark TEXT)";
     success = [db executeUpdate:sql];
     if(!success)
         {
         DLog(@"create T_HistoryMessage_TABLE  table failed,error:%@",[db lastErrorMessage]);
         }
     [db close];
     }];
    return success;
}

/**添加消息历史记录*/
- (void)addHistoryMessageInfoTableClassify:(MessageModel *)adModel
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *addSqlString = [NSString stringWithFormat:@"insert or replace into T_HistoryMessage_TABLE (messageId, messageTitle, messageContent, ctime, time,result,state,deviceId,pointId,userId,userName,type,isRead,uploadtime,remark) values ('%@', '%@', '%@', '%ld', '%@','%@', '%ld', '%@', '%@', '%@', '%@', '%@', '%@', '%lld', '%@')", adModel.messageId, adModel.messageTitle, adModel.messageContent, (long)adModel.ctime, adModel.time, adModel.result, (long)adModel.state, adModel.deviceId, adModel.pointId, adModel.userId,adModel.userName,adModel.type,adModel.isRead,adModel.uploadtime,adModel.remark];
     success = [db executeUpdate:addSqlString];
     if (success)
         {
         DLog(@"insert into T_HistoryMessage_TABLE success");
         }
     else
         {
         DLog(@"insert into T_HistoryMessage_TABLE failed, error:%@",[db lastErrorMessage]);
         }
     [db close];
     }];
    
}

/**获取消息历史记录表中的不同类型的数据*/
- (NSMutableArray *)getAllHistoryMessagesInfoWithType:(NSString *)type
{
    __block  NSMutableArray *mutable = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *findSqlString = [NSString stringWithFormat:@"select * from T_HistoryMessage_TABLE WHERE type='%@' order by ctime desc",type];
         FMResultSet *rs = [db executeQuery:findSqlString];
         while (rs && [rs next])
         {
             MessageModel *adObject = [[MessageModel alloc] init];
             adObject.messageId = [rs stringForColumn:@"messageId"];
             adObject.messageTitle = [rs stringForColumn:@"messageTitle"];
             adObject.messageContent = [rs stringForColumn:@"messageContent"];
             adObject.ctime = [rs longForColumn:@"ctime"];
             adObject.time = [rs stringForColumn:@"time"];
             adObject.result = [rs stringForColumn:@"result"];
             adObject.state = [rs longForColumn:@"state"];
             adObject.deviceId = [rs stringForColumn:@"deviceId"];
             adObject.pointId = [rs stringForColumn:@"pointId"];
             adObject.userId = [rs stringForColumn:@"userId"];
             adObject.userName = [rs stringForColumn:@"userName"];
             adObject.type = [rs stringForColumn:@"type"];
             adObject.isRead = [rs stringForColumn:@"isRead"];
             adObject.uploadtime = [rs longForColumn:@"uploadtime"];
             adObject.remark = [rs stringForColumn:@"remark"];
             [mutable addObject:adObject];
         }
         [db close];
     }];
    return mutable;
    
}

    //是否包含未读消息
- (NSInteger)getAllUnreadHistoryMessagesCount
{
    __block  NSInteger messagecount = 0;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM T_HistoryMessage_TABLE WHERE isRead = 0"];
     
     FMResultSet *rs = [db executeQuery:sqlString];
     while([rs next])
         {
         messagecount = [rs intForColumnIndex:0];
         }
     [db close];
     }];
    return messagecount;
}

/**批量修改某类型消息 为已读状态*/
- (BOOL)updateHistoryMessageReadStatusWithType:(NSString *)type
{
    __block BOOL success = NO;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *sqlString3 = [NSString stringWithFormat:@"update T_HistoryMessage_TABLE set isRead = '%@' where type = '%@' ",@"1",type];
         success = [db executeUpdate:sqlString3];
         [db close];
     }];
    return success;
}

//删除消息不同类型的历史记录数据
- (BOOL)deleteHistoryMessagesWithType:(NSString *)type
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *sqlString = [NSString stringWithFormat:@"delete from T_HistoryMessage_TABLE where type='%@'",type];
         success = [db executeUpdate:sqlString];
     
     if (!success)
         {
         DLog(@"delete from T_HistoryMessage_TABLE where type=%@ failed, error:%@",type,[db lastErrorMessage]);
         }
     
         [db close];
     }];
    return success;
}

/**根据消息id获取消息*/
- (MessageModel *)getHistoryMessagesInfoWithMessageId:(NSString *)messageId
{
    __block  MessageModel *useObject = [[MessageModel alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *findSqlString = [NSString stringWithFormat:@"select * from T_HistoryMessage_TABLE WHERE messageId='%@'",messageId];
         FMResultSet *rs = [db executeQuery:findSqlString];
         while (rs && [rs next])
         {
             MessageModel *adObject = [[MessageModel alloc] init];
             adObject.messageId = [rs stringForColumn:@"messageId"];
             adObject.messageTitle = [rs stringForColumn:@"messageTitle"];
             adObject.messageContent = [rs stringForColumn:@"messageContent"];
             adObject.ctime = [rs longForColumn:@"ctime"];
             adObject.time = [rs stringForColumn:@"time"];
             adObject.result = [rs stringForColumn:@"result"];
             adObject.state = [rs longForColumn:@"state"];
             adObject.deviceId = [rs stringForColumn:@"deviceId"];
             adObject.pointId = [rs stringForColumn:@"pointId"];
             adObject.userId = [rs stringForColumn:@"userId"];
             adObject.userName = [rs stringForColumn:@"userName"];
             adObject.type = [rs stringForColumn:@"type"];
             adObject.isRead = [rs stringForColumn:@"isRead"];
             adObject.uploadtime = [rs longForColumn:@"uploadtime"];
             adObject.remark = [rs stringForColumn:@"remark"];
             useObject = adObject;
         }
         [db close];
     }];
    return useObject;
    
}



@end
