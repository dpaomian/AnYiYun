//
//  MessageMaintainCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol MessageMaintainCellDeleagte <NSObject>

    //已处理
-(void)dealMaintainButtonActionWithItem:(MessageModel *)contentModel;

@end


/**
 消息待保养
 */
@interface MessageMaintainCell : UITableViewCell

@property (nonatomic,assign) id<MessageMaintainCellDeleagte> cellDelegate;

-(void)setCellContentWithModel:(MessageModel *)itemModel;



@end
