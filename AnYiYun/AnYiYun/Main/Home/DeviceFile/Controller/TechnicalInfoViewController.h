//
//  TechnicalInfoViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
/**
 技术资料
 */
@interface TechnicalInfoViewController : BaseViewController

@property (nonatomic,strong)NSString  *pushType;//区分哪个模块进入的

@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备位置

@end
