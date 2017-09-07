//
//  MessageExamCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol MessageExamCellDeleagte <NSObject>

    //已处理
-(void)dealExamButtonActionWithItem:(MessageModel *)contentModel;

@end


/**
 消息 待检修cell
 */
@interface MessageExamCell : UITableViewCell

@property (nonatomic,assign) id<MessageExamCellDeleagte> cellDelegate;

-(void)setCellContentWithModel:(MessageModel *)itemModel;

@end
