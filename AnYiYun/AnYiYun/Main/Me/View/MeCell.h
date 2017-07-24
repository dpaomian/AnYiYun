//
//  MeCell.h
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的模块 除个人资料外cell
 */
@interface MeCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomLineView;


/**
 cell

 @param titleString 文本
 @param imageString 本地图片
 @param type 特殊类型 1有未读消息 2清除缓存
 */
-(void)setCellContentWithTitle:(NSString *)titleString withImageString:(NSString *)imageString withType:(NSString *)type;

@end
