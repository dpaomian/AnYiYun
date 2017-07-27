//
//  MessageMaintainCell.h
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol MessageMaintainCellDeleagte <NSObject>

    //待处理
-(void)dealMaintainButtonActionWithItem:(MessageModel *)contentModel;
    //报修
-(void)repairMaintainButtonActionWithItem:(MessageModel *)contentModel;
    //曲线
-(void)curveMaintainButtonActionWithItem:(MessageModel *)contentModel;
    //定位
-(void)locationMaintainActionWithItem:(MessageModel *)contentModel;
@end


/**
 /**
 消息待保养
 */
@interface MessageMaintainCell : UITableViewCell

@property (nonatomic,assign) id<MessageMaintainCellDeleagte> cellDelegate;

-(void)setCellContentWithModel:(MessageModel *)itemModel;



@end
