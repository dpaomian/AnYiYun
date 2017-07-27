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
- (BOOL)createMessageHistoryTable;

/**添加消息历史记录*/
- (void)addMessageHistoryInfoTableClassify:(MessageModel *)adModel;

/**删除消息历史记录*/
- (BOOL)deleteMessageHistoryInfo:(NSString *)pidString;

/**获取消息历史记录表中的所有数据*/
- (NSMutableArray *)getAllMessageHistorysInfo;

    //删除消息历史记录数据
- (BOOL)deleteAllMessageHistorys;

@end
