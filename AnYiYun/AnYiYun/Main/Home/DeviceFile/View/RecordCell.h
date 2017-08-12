//
//  RecordCell.h
//  AnYiYun
//
//  Created by wuwanru on 29/7/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"
/**
  记录cell
 */
@interface RecordCell : UITableViewCell

-(void)setCellContentWithModel:(MessageModel *)itemModel withShowType:(NSString *)showType;


@end
