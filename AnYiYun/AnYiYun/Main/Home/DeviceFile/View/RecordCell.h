//
//  RecordCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 29/7/17.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"
/**
  记录cell
 */
@interface RecordCell : UITableViewCell

-(void)setCellContentWithModel:(MessageModel *)itemModel withShowType:(NSString *)showType;


@end
