//
//  LoadDetectionViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoadDetectionViewController.h"

@interface LoadDetectionViewController ()

@property (nonatomic, strong) NSMutableArray *constraintsMutableArray;
/*!记录被展开的区*/
@property (nonatomic, assign) NSInteger   foldSection;

@end

@implementation LoadDetectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foldSection = 0;
    
    __weak LoadDetectionViewController *ws = self;
    
    _conditionDic = [NSMutableDictionary dictionary];
    _listMutableArray = [NSMutableArray array];
    _constraintsMutableArray = [NSMutableArray array];
    
    [self getLoadDetectionData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"LoadDatectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionCell class]) bundle:nil] forCellReuseIdentifier:@"LoadDatectionCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FilterCollectionView *collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.selectedIndex = 0;
    [collectionView iteminitialization];
    collectionView.isFold = YES;
    collectionView.foldHandle = ^(FilterCollectionView *myCollectionView, BOOL isFold){
        [ws.view removeConstraints:ws.constraintsMutableArray];
        [ws.constraintsMutableArray removeAllObjects];
        if (isFold) {
            [ws.constraintsMutableArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[myCollectionView(==34)]" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(myCollectionView)]];
        } else {
            [ws.constraintsMutableArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[myCollectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(myCollectionView)]];
        }
        [ws.view addConstraints:ws.constraintsMutableArray];
    };
    collectionView.choiceHandle = ^(FilterCollectionView *myCollectionView, id modelObject, NSInteger idx) {
        switch (idx) {
            case 1:
            {
                FilterCompanyModel * model = modelObject;
                if ([model.idF isEqualToString:@"all"]) {
                    [ws.conditionDic removeObjectForKey:@"firstCondition"];
                } else {
                    [ws.conditionDic setObject:model.companyName forKey:@"firstCondition"];
                }
                [ws getLoadDetectionData];
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
                [ws getLoadDetectionData];
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
                [ws getLoadDetectionData];
            }
                break;
            case 4:
            {
                UISearchBar * bar = modelObject;
                [ws.conditionDic setObject:bar.text forKey:@"fifthCondition"];
                [ws getLoadDetectionData];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:collectionView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [_constraintsMutableArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView(==34)]" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:_constraintsMutableArray];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-34-[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
}

- (void)getLoadDetectionData {
    __weak LoadDetectionViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/energyData/loadMonitorFirst",BASE_PLAN_URL];
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_conditionDic options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"conditions":jsonString};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        [ws.listMutableArray removeAllObjects];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LoadDetectionModel *model = [[LoadDetectionModel alloc] init];
            model.idF = obj[@"id"];
            model.device_location = obj[@"device_location"];
            model.device_name = obj[@"device_name"];
            model.extend = obj[@"extend"];
            model.kind = obj[@"kind"];
            model.orgId = obj[@"orgId"];
            model.pointState = obj[@"pointState"];
            model.sid = obj[@"sid"];
            model.sort = obj[@"sort"];
            model.sortKey = obj[@"sortKey"];
            model.state = obj[@"state"];
            if (idx== 0) {
                ws.foldSection = idx;
                [ws loadItemWithModel:model andSection:idx];
                model.isFold = YES;
            } else {
                model.isFold = NO;
            }
            [ws.listMutableArray addObject:model];
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

- (void)loadItemWithModel:(LoadDetectionModel *)itemModel andSection:(NSInteger)section {
    __weak LoadDetectionViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/energyData/loadMonitorSecond",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"deviceId":itemModel.idF};
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
    return 24.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak LoadDetectionViewController *ws = self;
    
    LoadDatectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LoadDatectionHeaderView"];
    __block LoadDetectionModel *model = _listMutableArray[section];
    headerView.markButton.selected = model.isFold;
    headerView.titleLab.text = model.device_name;
    NSArray * array = [model.extend componentsSeparatedByString:@":"];
    headerView.contentLab.text =  ([array count]== 3)?[NSString stringWithFormat:@"%@ %@",array[1],array[2]]:@"0.0 kW";
    headerView.contentLab.font = [UIFont systemFontOfSize:12.0f];
    headerView.headerTouchHandle = ^(LoadDatectionHeaderView *dateHeaderView, BOOL isSelected){
        if (isSelected) {
            /*首先关闭原来的选项*/
            LoadDetectionModel *currentModel = _listMutableArray[ws.foldSection];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoadDatectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadDatectionCell" forIndexPath:indexPath];
    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
    RealtimeMonitoringListModelList *modelItem = model.itemsMutableArray[indexPath.row];
    cell.titleLab.text = modelItem.point_name;
    cell.contentLab.text = [NSString stringWithFormat:@"%@ %@",modelItem.point_value,modelItem.point_unit];
    return cell;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
