//
//  YYPasswordViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/25.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "YYPswCell.h"

@interface YYPasswordViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *passwordTableView;
@property (strong, nonatomic) IBOutlet UIButton *close;

@end
