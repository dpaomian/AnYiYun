//
//  MessageAlarmCell.h
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol MessageAlarmCellDeleagte <NSObject>

    //待处理
-(void)dealButtonActionWithItem:(MessageModel *)contentModel;
    //报修
-(void)repairButtonActionWithItem:(MessageModel *)contentModel;
    //曲线
-(void)curveButtonActionWithItem:(MessageModel *)contentModel;
    //定位
-(void)locationActionWithItem:(MessageModel *)contentModel;
@end


/**
 消息告警cell
 */
@interface MessageAlarmCell : UITableViewCell

@property (nonatomic,assign) id<MessageAlarmCellDeleagte> cellDelegate;

-(void)setCellContentWithModel:(MessageModel *)itemModel;

@end
