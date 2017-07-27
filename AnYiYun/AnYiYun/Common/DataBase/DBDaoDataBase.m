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
            if(![self createMessageHistoryTable])
                {
                return nil;
                }
            return self;
            }
        }
    return nil;
}




#pragma mark - 消息历史记录表 T_MessageHistory_TABLE
/**创建消息历史记录表*/
- (BOOL)createMessageHistoryTable
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sql = @"CREATE TABLE IF NOT EXISTS T_MessageHistory_TABLE(messageId    text primary key,\
     messageTitle   TEXT,\
     messageContent TEXT,\
     ctime  integer not null,\
     time TEXT,\
     result TEXT,\
     state  integer not null,\
     deviceId TEXT,\
     pointId TEXT,\
     userId TEXT,\
     userName TEXT)";
     success = [db executeUpdate:sql];
     if(!success)
         {
         DLog(@"create T_MessageHistory_TABLE  table failed,error:%@",[db lastErrorMessage]);
         }
     [db close];
     }];
    return success;
}

/**添加消息历史记录*/
- (void)addMessageHistoryInfoTableClassify:(MessageModel *)adModel
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *addSqlString = [NSString stringWithFormat:@"insert or replace into T_MessageHistory_TABLE (messageId, messageTitle, messageContent, ctime, time,result,state,deviceId,pointId,userId,userName) values ('%@', '%@', '%@', '%ld', '%@','%@', '%ld', '%@', '%@', '%@', '%@')", adModel.messageId, adModel.messageTitle, adModel.messageContent, (long)adModel.ctime, adModel.time, adModel.result, (long)adModel.state, adModel.deviceId, adModel.pointId, adModel.userId,adModel.userName];
     success = [db executeUpdate:addSqlString];
     if (success)
         {
         DLog(@"insert into T_MessageHistory_TABLE success");
         }
     else
         {
         DLog(@"insert into T_MessageHistory_TABLE failed, error:%@",[db lastErrorMessage]);
         }
     [db close];
     }];
    
}

/**删除消息历史记录*/
- (BOOL)deleteMessageHistoryInfo:(NSString *)pidString
{
    __block  BOOL success;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *selectSql = [NSString stringWithFormat:@"select * from T_MessageHistory_TABLE where messageId = '%@'", pidString];
     FMResultSet *set = [db executeQuery:selectSql];
     if ([set next])
         {
         NSString *deleteSql = [NSString stringWithFormat:@"delete from T_MessageHistory_TABLE where messageId = '%@'", pidString];
         success = [db executeUpdate:deleteSql];
         if (success)
             {
             DLog(@"delete T_MessageHistory_TABLE success");
             }
         else
             {
             DLog(@"delete T_MessageHistory_TABLE failed, error:%@",[db lastErrorMessage]);
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
- (NSMutableArray *)getAllMessageHistorysInfo
{
    __block  NSMutableArray *mutable = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *findSqlString = @"select * from T_MessageHistory_TABLE order by localId desc";
     FMResultSet *rs = [db executeQuery:findSqlString];
     while (rs && [rs next])
         {
         MessageModel *adObject = [[MessageModel alloc] init];
         adObject.messageId = [rs stringForColumn:@"messageId"];
         adObject.messageTitle = [rs stringForColumn:@"messageTitle"];
         adObject.messageContent = [rs stringForColumn:@"messageContent"];
         adObject.ctime = [rs intForColumn:@"ctime"];
         adObject.time = [rs stringForColumn:@"time"];
         adObject.result = [rs stringForColumn:@"result"];
         adObject.state = [rs intForColumn:@"state"];
         adObject.deviceId = [rs stringForColumn:@"deviceId"];
         adObject.pointId = [rs stringForColumn:@"pointId"];
         adObject.userId = [rs stringForColumn:@"userId"];
         adObject.userName = [rs stringForColumn:@"userName"];
         [mutable addObject:adObject];
         }
     [db close];
     }];
    return mutable;
    
}

/**获得某一消息历史记录数据*/
- (MessageModel *)getSingleADInfo:(NSString *)pidString
{
    __block  MessageModel *adObject = [[MessageModel alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     
     NSString *findSql = [NSString stringWithFormat:@"select * from T_MessageHistory_TABLE where messageId = '%@'", pidString];
     FMResultSet *rs = [db executeQuery:findSql];
     if (rs && [rs next])
         {
         adObject.messageId = [rs stringForColumn:@"messageId"];
         adObject.messageTitle = [rs stringForColumn:@"messageTitle"];
         adObject.messageContent = [rs stringForColumn:@"messageContent"];
         adObject.ctime = [rs intForColumn:@"ctime"];
         adObject.time = [rs stringForColumn:@"time"];
         adObject.result = [rs stringForColumn:@"result"];
         adObject.state = [rs intForColumn:@"state"];
         adObject.deviceId = [rs stringForColumn:@"deviceId"];
         adObject.pointId = [rs stringForColumn:@"pointId"];
         adObject.userId = [rs stringForColumn:@"userId"];
         adObject.userName = [rs stringForColumn:@"userName"];
         }
     [db close];
     }];
    return adObject;
    
}

    //删除消息历史记录数据
- (BOOL)deleteAllMessageHistorys
{
    __block BOOL success = NO;
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
     [db open];
     NSString *sqlString = @"delete from T_MessageHistory_TABLE ";
     success = [db executeUpdate:sqlString];
     [db close];
     }];
    return success;
}

@end
