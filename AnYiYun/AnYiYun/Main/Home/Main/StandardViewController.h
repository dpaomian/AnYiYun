//
//  StandardViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/9/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceInfoModel.h"
#import "PublicWebViewController.h"
#import "MBProgressHUD+YY.h"

/*!规程与标准*/
@interface StandardViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>

@property(nonatomic,strong) UIDocumentInteractionController *documentInteractionController;


@property (nonatomic,strong)UITableView *bgTableView;
@property (nonatomic,strong)NSMutableArray *datasource;

@property (nonatomic,strong)NSString *deviceIdString;//设备id
@property (nonatomic,strong)NSString *deviceNameString;//设备标题
@property (nonatomic,strong)NSString *deviceLocation;//设备位置

@end
