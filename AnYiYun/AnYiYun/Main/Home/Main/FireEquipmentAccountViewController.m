//
//  FireEquipmentAccountViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FireEquipmentAccountViewController.h"
#import "EquipmentAccountCell.h"
#import "RealtimeMonitoringListModel.h"
#import "DeviceFileViewController.h"

@interface FireEquipmentAccountViewController ()

@end

@implementation FireEquipmentAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listMutableDic = [NSMutableDictionary dictionary];
    [self getAlarmInformationData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.sectionIndexColor = UIColorFromRGB(0x3D3D3D);
    self.tableView.sectionIndexBackgroundColor = UIColorFromRGBA(0x666666,0.4f);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EquipmentAccountCell class]) bundle:nil] forCellReuseIdentifier:@"EquipmentAccountCell"];
}

- (NSArray *)sortKeysWithDic:(NSDictionary *)dic {
    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedKeys;
}

- (void)getAlarmInformationData {
    __weak FireEquipmentAccountViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/electricalFire/deviceLedger",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        /*使用字典取sortKey，起到自动去重的效果*/
        __block NSMutableDictionary * sortKeyDic = [NSMutableDictionary dictionary];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [sortKeyDic setObject:@"1" forKey:obj[@"sortKey"]];
        }];
        [ws.listMutableDic removeAllObjects];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RealtimeMonitoringListModel *model = [[RealtimeMonitoringListModel alloc] init];
            model.idF = obj[@"id"];
            model.device_location = obj[@"device_location"];
            model.device_name = obj[@"device_name"];
            model.kind = obj[@"kind"];
            model.orgId = obj[@"orgId"];
            model.sid = obj[@"sid"];
            model.sort = obj[@"sort"];
            model.sortKey = obj[@"sortKey"];
            model.state = obj[@"state"];
            [[ws sortKeysWithDic:sortKeyDic] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.sortKey isEqualToString:obj]) {
                    NSMutableArray *currentModes = [NSMutableArray arrayWithArray:ws.listMutableDic[obj]];
                    [currentModes addObject:model];
                    [ws.listMutableDic setObject:currentModes forKey:obj];
                }
            }];
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_listMutableDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * currentArray = [self sortKeysWithDic:_listMutableDic];
    NSString *keyString = currentArray[section];
    return [_listMutableDic[keyString] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {\
    NSArray * currentArray = [self sortKeysWithDic:_listMutableDic];
    NSString *keyString = currentArray[section];
    return keyString;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"#"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * currentArray = [self sortKeysWithDic:_listMutableDic];
    NSString *keyString = currentArray[indexPath.section];
    NSArray *modelsArray = _listMutableDic[keyString];
    RealtimeMonitoringListModel *model = modelsArray[indexPath.row];
    EquipmentAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentAccountCell" forIndexPath:indexPath];
    cell.titleLab.text = model.device_name;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * currentArray = [self sortKeysWithDic:_listMutableDic];
    NSString *keyString = currentArray[indexPath.section];
    NSArray *modelsArray = _listMutableDic[keyString];
    RealtimeMonitoringListModel *model = modelsArray[indexPath.row];
    /*model待传入下级页面*/
    
    DeviceFileViewController *vc = [[DeviceFileViewController alloc]init];
    vc.deviceNameString = model.device_name;
    vc.deviceIdString = model.idF;
    vc.deviceLocation = model.device_location;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
