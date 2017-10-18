//
//  YYNavViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface YYNavViewController : BaseViewController

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;

@end
