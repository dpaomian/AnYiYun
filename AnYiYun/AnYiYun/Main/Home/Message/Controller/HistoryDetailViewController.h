//
//  HistoryDetailViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"

/**
 历史消息 待检修／待保养列表
 */
@interface HistoryDetailViewController : BaseViewController

@property (nonatomic,strong)HistoryMessageModel *groupItemModel;
@property (nonatomic,strong)NSString *typeString;

@property (nonatomic,strong)NSString *typeTitleString;

@end
