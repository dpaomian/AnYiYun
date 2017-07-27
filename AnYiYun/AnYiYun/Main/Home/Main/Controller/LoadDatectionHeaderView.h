//
//  LoadDatectionHeaderView.h
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>

/*负荷监测区头*/
@interface LoadDatectionHeaderView : UITableViewHeaderFooterView

/*!区头的背景视图*/
@property (strong, nonatomic) IBOutlet UIView *bgView;
/*!前边的展开折叠图标*/
@property (strong, nonatomic) IBOutlet UIButton *markButton;
/*!标题*/
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
/*!后边的内容*/
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
/*!尾部的小图片*/
@property (strong, nonatomic) IBOutlet UIImageView *tailImage;
@property (strong, nonatomic) IBOutlet UIButton *touchButton;

/*!区头被点击*/
@property (nonatomic, copy) void (^headerTouchHandle)(LoadDatectionHeaderView *dateHeaderView, BOOL isSelected);

@property (nonatomic, copy) void (^headerTouch)();

@end
