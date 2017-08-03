//
//  LoadDetectionViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoadDetectionViewController.h"
#import "SecondViewController.h"

@interface LoadDetectionViewController ()

@property (nonatomic, strong) NSMutableArray *constraintsMutableArray;
/*!记录被展开的区*/
@property (nonatomic, assign) NSInteger   foldSection;
@property (nonatomic, strong) SecondViewController *sVC;

@end

@implementation LoadDetectionViewController

- (void)buttonClick:(UIButton *)sender {
    SecondViewController *vc = [[SecondViewController alloc] init];
    vc.tTitle = _sVC.tTitle;
    vc.oneArray = _sVC.oneArray;
    vc.twoArray = _sVC.twoArray;
    vc.timeArray = _sVC.timeArray;
    vc.view.transform=CGAffineTransformMakeRotation(M_PI/2);
    vc.chartView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    vc.chartView.contentHeight = SCREEN_WIDTH;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foldSection = 0;
    
    __weak LoadDetectionViewController *ws = self;
    
    _conditionDic = [NSMutableDictionary dictionary];
    _listMutableArray = [NSMutableArray array];
    _constraintsMutableArray = [NSMutableArray array];
    _curveMutableArray1 = [NSMutableArray array];
    _curveMutableArray2 = [NSMutableArray array];
    
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
    [self.view addSubview:collectionView];
    //曲线图
    _sVC = [[SecondViewController alloc]init];
    _sVC.SecondeViewControllerChartType = 5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*SCREEN_WIDTH/SCREEN_HEIGHT)];
    [view addSubview:_sVC.view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(8, 4, 40, 33);
    [button setImage:[UIImage imageNamed:@"all_icon_5.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    view.clipsToBounds = YES;
    [self.view addSubview:view];
    
    float tableViewTop = SCREEN_WIDTH*SCREEN_WIDTH/SCREEN_HEIGHT;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [_constraintsMutableArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[collectionView(==%d)]",34] options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:_constraintsMutableArray];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_tableView]|",tableViewTop] options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getLoadDetectionData];
    }];
    [self.tableView.mj_header beginRefreshing];
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
                [ws loadCurveWithModel:model andSection:idx];
                ws.sVC.tTitle = model.device_name;
                [ws.sVC reloadDataUI];
                model.isFold = YES;
            } else {
                model.isFold = NO;
            }
            [ws.listMutableArray addObject:model];
        }];
        [self.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
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
            RealtimeMonitoringListModelList *model = [[RealtimeMonitoringListModelList alloc] init];
            model.device_id = obj[@"device_id"];
            model.device_name = obj[@"device_name"];
            model.displayIcon = [obj[@"displayIcon"] boolValue];
            model.idF = obj[@"id"];
            model.point_name = obj[@"point_name"];
            model.point_state = obj[@"point_state"];
            model.point_type = obj[@"point_type"];
            model.point_unit = obj[@"point_unit"];
            model.point_value = obj[@"point_value"];
            model.sid = obj[@"sid"];
            model.sortDevice = obj[@"sortDevice"];
            model.terminal_id = obj[@"terminal_id"];
            model.terminal_type = obj[@"terminal_type"];
            [childItemsMutablearray addObject:model];
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

- (void)loadCurveWithModel:(LoadDetectionModel *)itemModel andSection:(NSInteger)section {
    __weak LoadDetectionViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/doubleGraph",BASE_PLAN_URL];
    NSArray * array = [NSArray arrayWithArray:[[itemModel extend] componentsSeparatedByString:@":"]];
    NSString * idString = [array count]>0?array[0]:@"";
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"pointId":idString,@"type":@"103"};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        [ws.curveMutableArray1 removeAllObjects];
        [ws.curveMutableArray2 removeAllObjects];
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * value1Array = [NSArray arrayWithArray:obj];
            NSInteger myIdex = idx;
            NSMutableArray *arrayOne = [NSMutableArray array];
            NSMutableArray *arrayTwo = [NSMutableArray array];
            NSMutableArray *timeArray = [NSMutableArray array];
            [value1Array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DoubleGraphModel *model = [[DoubleGraphModel alloc] init];
                model.idf = obj[@"id"];
                model.name = obj[@"name"];
                model.sid = obj[@"sid"];
                model.time = obj[@"time"];
                model.timeLong = obj[@"timeLong"];
                model.value = obj[@"value"];
                float numberToRound;
                int result;
                numberToRound = [model.value floatValue];
                
                result = (int)roundf(numberToRound);
                if (myIdex==0) {
                    [ws.curveMutableArray1 addObject:model];
                    [arrayOne addObject:@(result)];
                } else {
                    [ws.curveMutableArray2 addObject:model];
//                     NSLog(@"roundf(%.2f) = %d", numberToRound, result);
                    [arrayTwo addObject:@(result)];
                    [timeArray addObject:model.time];
                }
            }];
            if (myIdex==0) {
                _sVC.oneArray = [NSArray arrayWithArray:arrayOne];
            } else {
                _sVC.twoArray = [NSArray arrayWithArray:arrayTwo];
                _sVC.timeArray = [NSArray arrayWithArray:timeArray];
            }
        }];

        [_sVC reloadDataUI];
//        [self.stockDatadict setObject:array forKey:@"1"];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"获取曲线失败"];
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
    headerView.tailImage.image = [UIImage imageNamed:([model.state integerValue] == 1) ? @"onLine.png":@"outLine.png"];
    __block LoadDatectionHeaderView *hView = headerView;
    headerView.headerTouchHandle = ^(LoadDatectionHeaderView *dateHeaderView, BOOL isSelected){
        if (isSelected) {
            /*首先关闭原来的选项*/
            LoadDetectionModel *currentModel = _listMutableArray[ws.foldSection];
            currentModel.isFold = NO;
            currentModel.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:ws.foldSection] withRowAnimation:UITableViewRowAnimationNone];
            ws.sVC.tTitle = hView.titleLab.text;
            [ws.sVC reloadDataUI];
            ws.foldSection = section;
            model.isFold = YES;
            [ws loadItemWithModel:model andSection:section];
            [ws loadCurveWithModel:model andSection:section];
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
    cell.tailImageView.image = [UIImage imageNamed:([model.state integerValue]==1)?@"onLine.png":@"outLine.png"];
    return cell;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
