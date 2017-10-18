//
//  YYNaverBottomView.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/18.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface YYNaverBottomView : UIView<UITableViewDelegate,UITableViewDataSource>

/*!方案*/
@property (nonatomic, strong) UITableView    *programmeTableView;
/*!路线*/
@property (nonatomic, strong) NSMutableArray    *linksMutableArray;

@end
