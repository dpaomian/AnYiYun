//
//  MessageModel.h
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,assign) long     messageId;
@property (nonatomic,strong) NSString *messageTitle;
@property (nonatomic,strong) NSString *messageContent;
@property (nonatomic,assign) long  ctime;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *result;
@property (nonatomic,assign) NSInteger state;

@end
