//
//  MessageNoticeTableViewCell.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/18.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end
