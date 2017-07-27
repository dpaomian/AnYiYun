//
//  MessageModel.h
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,strong) NSString  *messageId;
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

- (id)initWithDictionary:(NSDictionary *)userDictionary;


@end
