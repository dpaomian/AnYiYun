//
//  FirePowerSupplyEquipmentAccountViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FirePowerSupplyEquipmentAccountViewController.h"
#import "EquipmentAccountCell.h"
#import "RealtimeMonitoringListModel.h"
#import "DeviceFileViewController.h"

@interface FirePowerSupplyEquipmentAccountViewController ()

@end

@implementation FirePowerSupplyEquipmentAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listMutableDic = [NSMutableDictionary dictionary];
    _conditionDic = [NSMutableDictionary dictionary];
    
    __weak FirePowerSupplyEquipmentAccountViewController *ws = self;
    
    self.tableView.sectionIndexColor = UIColorFromRGB(0x3D3D3D);
    self.tableView.sectionIndexBackgroundColor = UIColorFromRGBA(0x666666,0.4f);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EquipmentAccountCell class]) bundle:nil] forCellReuseIdentifier:@"EquipmentAccountCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f) collectionViewLayout:flowLayout];
    _collectionView.selectedIndex = 0;
    [_collectionView iteminitialization];
    _collectionView.isFold = YES;
    _collectionView.foldHandle = ^(FilterCollectionView *mycollectionView, BOOL isFold){
        if (isFold) {
            ws.collectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f);
        } else {
            ws.collectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT);
        }
    };
    _collectionView.choiceHandle = ^(FilterCollectionView *myCollectionView, id modelObject, NSInteger idx) {
        switch (idx) {
            case 1:
            {
                FilterCompanyModel * model = modelObject;
                if ([model.idF isEqualToString:@"all"]) {
                    [ws.conditionDic removeObjectForKey:@"firstCondition"];
                } else {
                    [ws.conditionDic setObject:model.companyName forKey:@"firstCondition"];
                }
                [ws.tableView.mj_header beginRefreshing];
            }
                break;
            case 2:
            {
                BuildingModle * model = modelObject;
                if ([model.idF isEqualToString:@"all"]) {
                    [ws.conditionDic removeObjectForKey:@"secondCondition"];
                } else {
                    [ws.conditionDic setObject:model.name forKey:@"secondCondition"];
                }
                [ws.tableView.mj_header beginRefreshing];
            }
                break;
            case 3:
            {
                SortModel * model = modelObject;
                if ([model.idF isEqualToString:@"500"]) {
                    [ws.conditionDic removeObjectForKey:@"thirdCondition"];
                } else{
                    [ws.conditionDic setObject:model.idF forKey:@"thirdCondition"];
                }
                [ws.tableView.mj_header beginRefreshing];
            }
                break;
            case 4:
            {
                UISearchBar * bar = modelObject;
                [ws.conditionDic setObject:bar.text forKey:@"fifthCondition"];
                [ws.tableView.mj_header beginRefreshing];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_collectionView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getAlarmInformationData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSArray *)sortKeysWithDic:(NSDictionary *)dic {
    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedKeys;
}

- (void)getAlarmInformationData {
    __weak FirePowerSupplyEquipmentAccountViewController *ws = self;
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_conditionDic options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/firePower/deviceLedger",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"conditions":jsonString};
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
            if ([ws.conditionDic[@"fifthCondition"] length] > 0) {
                NSString *keyString = ws.conditionDic[@"fifthCondition"]?ws.conditionDic[@"fifthCondition"]:@"";
                if (!([model.device_name rangeOfString:keyString].location == NSNotFound) ||
                    !([model.device_location rangeOfString:keyString].location == NSNotFound)) {
                    [[ws sortKeysWithDic:sortKeyDic] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([model.sortKey isEqualToString:obj]) {
                            NSMutableArray *currentModes = [NSMutableArray arrayWithArray:ws.listMutableDic[obj]];
                            [currentModes addObject:model];
                            [ws.listMutableDic setObject:currentModes forKey:obj];
                        }
                    }];
                } else {
                    NSLog(@"没有");
                }
            } else {
                [[ws sortKeysWithDic:sortKeyDic] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([model.sortKey isEqualToString:obj]) {
                        NSMutableArray *currentModes = [NSMutableArray arrayWithArray:ws.listMutableDic[obj]];
                        [currentModes addObject:model];
                        [ws.listMutableDic setObject:currentModes forKey:obj];
                    }
                }];
            }
        }];
        [self.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
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
