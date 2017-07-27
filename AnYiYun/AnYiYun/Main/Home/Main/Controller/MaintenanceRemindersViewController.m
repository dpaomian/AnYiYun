//
//  MaintenanceRemindersViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MaintenanceRemindersViewController.h"
#import "LoadDatectionHeaderView.h"

@interface MaintenanceRemindersViewController ()

@property (nonatomic, assign) NSInteger   foldSection;

@end

@implementation MaintenanceRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _foldSection = 0;
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    [self getRealtimeMonitoringData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"LoadDatectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RealtimeMonitoringChildCell class]) bundle:nil] forCellReuseIdentifier:@"RealtimeMonitoringChildCell"];
}

- (void)getRealtimeMonitoringData {
    RealtimeMonitoringListModel *fixmodel = [[RealtimeMonitoringListModel alloc] init];
    fixmodel.idF = @"rest/supplyPower/repair";
    fixmodel.device_name = @"待检修";
    fixmodel.isFold = YES;
    [self.listMutableArray addObject:fixmodel];
    
    RealtimeMonitoringListModel *maintenanceModel = [[RealtimeMonitoringListModel alloc] init];

    maintenanceModel.idF = @"rest/supplyPower/change";
    maintenanceModel.device_name = @"待保养";
    maintenanceModel.isFold = NO;
    [self.listMutableArray addObject:maintenanceModel];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_listMutableArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RealtimeMonitoringListModel *model = _listMutableArray[section];
    return [model.itemsMutableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    __weak MaintenanceRemindersViewController *ws = self;
    
    LoadDatectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LoadDatectionHeaderView"];
    __block RealtimeMonitoringListModel *model = _listMutableArray[section];
    headerView.markButton.selected = model.isFold;
    headerView.tailImage.hidden = YES;
    headerView.titleLab.text = model.device_name;
    headerView.contentLab.text = model.device_location;
    headerView.contentLab.font = [UIFont systemFontOfSize:12.0f];
    headerView.headerTouchHandle = ^(LoadDatectionHeaderView *dateHeaderView, BOOL isSelected){
        if (isSelected) {
            /*首先关闭原来的选项*/
            RealtimeMonitoringListModel *currentModel = _listMutableArray[ws.foldSection];
            currentModel.isFold = NO;
            currentModel.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:ws.foldSection] withRowAnimation:UITableViewRowAnimationNone];
            
            ws.foldSection = section;
            model.isFold = YES;
            [ws loadItemWithModel:model andSection:section];
        } else {
            model.isFold = NO;
            model.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            /*折叠状态*/
        }
    };
    return headerView;
}

- (void)loadItemWithModel:(RealtimeMonitoringListModel *)itemModel andSection:(NSInteger)section {
    __weak MaintenanceRemindersViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,itemModel.idF];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        itemModel.itemsMutableArray = [@[] mutableCopy];
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        NSMutableArray *childItemsMutablearray = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RealtimeMonitoringListModelList *itemModel = [[RealtimeMonitoringListModelList alloc] init];
            itemModel.device_id = obj[@"device_id"];
            itemModel.device_name = obj[@"device_name"];
            itemModel.displayIcon = [obj[@"displayIcon"] boolValue];
            itemModel.idF = obj[@"id"];
            itemModel.point_name = obj[@"point_name"];
            itemModel.point_state = obj[@"point_state"];
            itemModel.point_type = obj[@"point_type"];
            itemModel.point_unit = obj[@"point_unit"];
            itemModel.point_value = obj[@"point_value"];
            itemModel.sid = obj[@"sid"];
            itemModel.sortDevice = obj[@"sortDevice"];
            itemModel.terminal_id = obj[@"terminal_id"];
            itemModel.terminal_type = obj[@"terminal_type"];
            [childItemsMutablearray addObject:itemModel];
        }];
        itemModel.itemsMutableArray =childItemsMutablearray;
        [ws.listMutableArray replaceObjectAtIndex:section withObject:itemModel];
        [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } failureBlock:^(NSError *error) {
        itemModel.itemsMutableArray = [@[] mutableCopy];
        [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RealtimeMonitoringChildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RealtimeMonitoringChildCell" forIndexPath:indexPath];
    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
    RealtimeMonitoringListModelList *modelItem = model.itemsMutableArray[indexPath.row];
    cell.titleLab.text = modelItem.point_name;
    [cell.contentBtn setTitle:[NSString stringWithFormat:@"   %@  %@",modelItem.point_value,modelItem.point_unit] forState:UIControlStateNormal];
    if (modelItem.displayIcon) {
        [cell.contentBtn setImage:[UIImage imageNamed:@"all_icon_2.png"] forState:UIControlStateNormal];
    } else {
        [cell.contentBtn setImage:nil forState:UIControlStateNormal];
    }
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
