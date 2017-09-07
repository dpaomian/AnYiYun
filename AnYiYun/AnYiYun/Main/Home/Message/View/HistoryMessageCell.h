//
//  HistoryMessageCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/27.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface HistoryMessageCell : UITableViewCell

-(void)setCellContentWithModel:(HistoryMessageModel *)itemModel;

@end
