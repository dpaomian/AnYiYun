//
//  HistoryDetailCell.h
//  AnYiYun
//
//  Created by wwr on 2017/7/27.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"

@interface HistoryDetailCell : UITableViewCell

-(void)setCellContentWithModel:(MessageModel *)itemModel;

@end
