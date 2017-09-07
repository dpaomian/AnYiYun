//
//  FireAlarmInformationModel.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/29.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

/*!告警信息*/
@interface FireAlarmInformationModel : NSObject

@property (nonatomic, copy) NSString *idF;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *pointId;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

/*!袁经理  18:08:57  2017-07-29
 这个state是告警信息处理状态，1代表已处理，0代表未处理。在你这消息中心没有用，消息中心都是服务端过滤过的，未处理的
 */
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *title;

- (MessageModel *)conversionToMessModelWith:(FireAlarmInformationModel *)model;

@end
