    //
    //  DBDaoDataBase.m
    //  xuexin
    //
    //  Created by mac on 15/6/19.
    //  Copyright (c) 2015年 mx. All rights reserved.
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
            if(![self createHistoryMessageTable])
                {
                return nil;
                }
            return self;
            }
        }
    return nil;
}




#pragma mark - 消息历史记录表 T_HistoryMessage_TABLE
/**创建消息历史记录表*/
- (BOOL)createHistoryMessageTable
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sql = @"CREATE TABLE IF NOT EXISTS T_HistoryMessage_TABLE(messageId    integer not null primary key,\
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
     NSString *addSqlString = [NSString stringWithFormat:@"insert or replace into T_HistoryMessage_TABLE (messageId, messageTitle, messageContent, ctime, time,result,state,deviceId,pointId,userId,userName,type,isRead,uploadtime,remark) values ('%ld', '%@', '%@', '%ld', '%@','%@', '%ld', '%@', '%@', '%@', '%@', '%@', '%@', '%lld', '%@')", (long)adModel.messageId, adModel.messageTitle, adModel.messageContent, (long)adModel.ctime, adModel.time, adModel.result, (long)adModel.state, adModel.deviceId, adModel.pointId, adModel.userId,adModel.userName,adModel.type,adModel.isRead,adModel.uploadtime,adModel.remark];
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


/**查询是否有未读消息 传空 查询全部 1待检修 2待保养*/
- (BOOL)isHaveNoReadHistoryMessageWithType:(NSString *)type
{
    __block  BOOL success;
    
    __block  NSInteger messagecount = 0;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *sqlString;
         if (type.length==0)
         {
             sqlString = @"SELECT COUNT(*) FROM T_HistoryMessage_TABLE where isRead = 0";
         }
         else
         {
             sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM T_HistoryMessage_TABLE where type='%@' and isRead = 0",type];
         }
         FMResultSet *rs = [db executeQuery:sqlString];
         while([rs next])
         {
             messagecount = [rs intForColumnIndex:0];
         }
         [db close];
     }];
    
    if (messagecount>0)
    {
        success=YES;
    }
    else
    {
        success=NO;
    }
    return success;
}

/**删除消息历史记录*/
- (BOOL)deleteHistoryMessageInfo:(NSString *)pidString
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *selectSql = [NSString stringWithFormat:@"select * from T_HistoryMessage_TABLE where messageId = '%ld'", (long)[pidString integerValue]];
     FMResultSet *set = [db executeQuery:selectSql];
     if ([set next])
         {
         NSString *deleteSql = [NSString stringWithFormat:@"delete from T_HistoryMessage_TABLE where messageId = '%ld'", (long)[pidString integerValue]];
         success = [db executeUpdate:deleteSql];
         if (success)
             {
             DLog(@"delete T_HistoryMessage_TABLE success");
             }
         else
             {
             DLog(@"delete T_HistoryMessage_TABLE failed, error:%@",[db lastErrorMessage]);
             }
         [db close];
         }
     else
         {
         success = NO;
         }
     }];
    return success;
}

/**获取消息历史记录表中的所有数据*/
- (NSMutableArray *)getAllHistoryMessagesInfo
{
    __block  NSMutableArray *mutable = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *findSqlString = @"select * from T_HistoryMessage_TABLE order by messageId desc";
     FMResultSet *rs = [db executeQuery:findSqlString];
     while (rs && [rs next])
         {
         MessageModel *adObject = [[MessageModel alloc] init];
         adObject.messageId = [rs longForColumn:@"messageId"];
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

/**获取消息历史记录表中的不同类型的数据*/
- (NSMutableArray *)getAllHistoryMessagesInfoWithType:(NSString *)type
{
    __block  NSMutableArray *mutable = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *findSqlString = [NSString stringWithFormat:@"select * from T_HistoryMessage_TABLE WHERE type='%@' order by messageId desc",type];
         FMResultSet *rs = [db executeQuery:findSqlString];
         while (rs && [rs next])
         {
             MessageModel *adObject = [[MessageModel alloc] init];
             adObject.messageId = [rs longForColumn:@"messageId"];
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
             adObject.messageId = [rs longForColumn:@"messageId"];
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

//删除消息不同类型的历史记录数据
- (BOOL)deleteHistoryMessagesWithType:(NSString *)type
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         [db open];
         NSString *sqlString = [NSString stringWithFormat:@"delete from T_HistoryMessage_TABLE where type='%@'",type];
         success = [db executeUpdate:sqlString];
         
         [db close];
     }];
    return success;
}

/**获得某一消息历史记录数据*/
- (MessageModel *)getSingleADInfo:(NSString *)pidString
{
    __block  MessageModel *adObject = [[MessageModel alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     
     NSString *findSql = [NSString stringWithFormat:@"select * from T_HistoryMessage_TABLE where messageId = '%@'", pidString];
     FMResultSet *rs = [db executeQuery:findSql];
     if (rs && [rs next])
         {
             adObject.messageId = [rs longForColumn:@"messageId"];
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
         }
     [db close];
     }];
    return adObject;
    
}

    //删除消息历史记录数据
- (BOOL)deleteAllHistoryMessages
{
    __block BOOL success = NO;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sqlString = @"delete from T_HistoryMessage_TABLE ";
     success = [db executeUpdate:sqlString];
     [db close];
     }];
    return success;
}

@end
