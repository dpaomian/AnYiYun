//
//  FirePowerSupplyMaintenanceRemindersViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "FirePowerSupplyMaintenanceRemindersViewController.h"
#import "LoadDatectionHeaderView.h"
#import "MaintenanceRemindersCell.h"

@interface FirePowerSupplyMaintenanceRemindersViewController ()

@property (nonatomic, assign) NSInteger   foldSection;

@end

@implementation FirePowerSupplyMaintenanceRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foldSection = 0;
    
    __weak FirePowerSupplyMaintenanceRemindersViewController *ws = self;
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"LoadDatectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MaintenanceRemindersCell class]) bundle:nil] forCellReuseIdentifier:@"MaintenanceRemindersCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getRealtimeMonitoringData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getRealtimeMonitoringData {
    [self.listMutableArray removeAllObjects];
    RealtimeMonitoringListModel *fixmodel = [[RealtimeMonitoringListModel alloc] init];
    fixmodel.idF = @"rest/firePower/repair";
    fixmodel.device_name = @"待检修";
    fixmodel.isFold = YES;
    [self loadItemWithModel:fixmodel andSection:0];
    [self.listMutableArray addObject:fixmodel];
    
    RealtimeMonitoringListModel *maintenanceModel = [[RealtimeMonitoringListModel alloc] init];

    maintenanceModel.idF = @"rest/firePower/change";
    maintenanceModel.device_name = @"待保养";
    maintenanceModel.isFold = NO;
    [self.listMutableArray addObject:maintenanceModel];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_listMutableArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RealtimeMonitoringListModel *model = _listMutableArray[section];
    return model.isFold?[model.itemsMutableArray count]:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    __weak FirePowerSupplyMaintenanceRemindersViewController *ws = self;
    
    LoadDatectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LoadDatectionHeaderView"];
    __block RealtimeMonitoringListModel *model = _listMutableArray[section];
    headerView.markButton.selected = model.isFold;
    headerView.tailImage.hidden = YES;
    headerView.titleLab.text = model.device_name;
    headerView.contentLab.text = [NSString stringWithFormat:@"%d",[model.itemsMutableArray count]];
    headerView.contentLab.font = [UIFont systemFontOfSize:12.0f];
    headerView.contentLab.textColor = UIColorFromRGB(0xF44336);
    headerView.headerTouchHandle = ^(LoadDatectionHeaderView *dateHeaderView, BOOL isSelected){
        if (isSelected) {
            /*首先关闭原来的选项*/
            RealtimeMonitoringListModel *currentModel = _listMutableArray[ws.foldSection];
            currentModel.isFold = NO;
//            currentModel.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:ws.foldSection] withRowAnimation:UITableViewRowAnimationNone];
            
            ws.foldSection = section;
            model.isFold = YES;
            [ws loadItemWithModel:model andSection:section];
        } else {
            model.isFold = NO;
//            model.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            /*折叠状态*/
        }
    };
    return headerView;
}

- (void)loadItemWithModel:(RealtimeMonitoringListModel *)itemModel andSection:(NSInteger)section {
    __weak FirePowerSupplyMaintenanceRemindersViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,itemModel.idF];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        itemModel.itemsMutableArray = [@[] mutableCopy];
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        NSMutableArray *childItemsMutablearray = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FireMaintenanceRemindersModel *itemModel = [[FireMaintenanceRemindersModel alloc] init];
            itemModel.idF = obj[@"id"];
            itemModel.content = obj[@"content"];
            itemModel.ctime = obj[@"ctime"];
            itemModel.time = obj[@"time"];
            itemModel.title = obj[@"title"];
            [childItemsMutablearray addObject:itemModel];
        }];
        itemModel.itemsMutableArray =childItemsMutablearray;
        [ws.listMutableArray replaceObjectAtIndex:section withObject:itemModel];
        [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        itemModel.itemsMutableArray = [@[] mutableCopy];
        [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak FirePowerSupplyMaintenanceRemindersViewController *ws = self;
    
    MaintenanceRemindersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenanceRemindersCell" forIndexPath:indexPath];
    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
    FireMaintenanceRemindersModel *modelItem = model.itemsMutableArray[indexPath.row];
    cell.nameLab.text = modelItem.title;
    cell.contentLab.text = modelItem.content;
    cell.timeLab.text = modelItem.time;
    [cell.stateButton buttonClickedHandle:^(UIButton *sender) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要选择\"已处理\"么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [NSString stringWithFormat:@"%@rest/process/todoP",BASE_PLAN_URL];
            NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                                    @"todoId":modelItem.idF,
                                    @"type":indexPath.section==0?@"1":@"2"};
            
            [MBProgressHUD showMessage:@"提交中..."];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:urlString
              parameters:param
                progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [MBProgressHUD hideHUD];
                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    BOOL dealState  = [string boolValue];
                    if (dealState==NO)
                        {
                        [BaseHelper waringInfo:@"处理失败"];
                        } else {
                            [MBProgressHUD showSuccess:@"已处理成功"];
                        }
                    [ws.tableView.mj_header beginRefreshing];
                }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     [MBProgressHUD hideHUD];
                     [MBProgressHUD showError:@"处理失败"];
                 }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [ws presentViewController:alertController animated:YES completion:nil];
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
    FireMaintenanceRemindersModel *modelItem = model.itemsMutableArray[indexPath.row];
    /*拿model自己处理*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
