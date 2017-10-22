//
//  YYNaverBottomView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/18.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "YYSubtitleTableViewCell.h"
#import "YYTransitListModel.h"

@interface YYNaverBottomView : UIView<UITableViewDelegate,UITableViewDataSource>

/*!方案*/
@property (nonatomic, strong) UITableView    *programmeTableView;
/*!是否是公交方案，默认为NO方案*/
@property (nonatomic, assign) BOOL           isTransit;
/*!路线*/
@property (nonatomic, strong) NSMutableArray    *linksMutableArray;

@property (nonatomic, copy) void (^didSelectRowAtIndexPath) (YYNaverBottomView *yyBottomView, YYTransitListModel *yyListModel, NSIndexPath * yyIndexPath);

@end
