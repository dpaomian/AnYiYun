//
//  MessageAlarmCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol MessageAlarmCellDeleagte <NSObject>

    //待处理
-(void)dealAlarmButtonActionWithItem:(MessageModel *)contentModel;
    //报修
-(void)repairAlarmButtonActionWithItem:(MessageModel *)contentModel;
    //曲线
-(void)curveAlarmButtonActionWithItem:(MessageModel *)contentModel;
    //定位
-(void)locationAlarmActionWithItem:(MessageModel *)contentModel;
@end


/**
 消息告警cell
 */
@interface MessageAlarmCell : UITableViewCell

@property (nonatomic,assign) id<MessageAlarmCellDeleagte> cellDelegate;

-(void)setCellContentWithModel:(MessageModel *)itemModel;

@end
