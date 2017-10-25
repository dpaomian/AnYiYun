//
//  MessSettingViewController.h
//  AnYiYun
//
//  Created by 韩亚周 on 2017/10/17.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "BaseViewController.h"
#import "EquipmentAccountHeaderFooterView.h"
#import "MessageStrategyCell.h"
#import "MessageStrategyModel.h"

@interface MessSettingViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView      *messageSettingTableView;

@property (nonatomic, strong) NSMutableArray   *listMutableArray;
@property (nonatomic, strong) MessageStrategyModel   *currentModel;
@property (nonatomic, strong) UIButton   *saveButton;

@end
