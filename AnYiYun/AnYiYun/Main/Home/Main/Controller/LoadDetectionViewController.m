//
//  LoadDetectionViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "LoadDetectionViewController.h"

@interface LoadDetectionViewController ()

/*!记录被展开的区*/
@property (nonatomic, strong) LoadDetectionModel   *foldSectionModel;

@end

@implementation LoadDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foldSectionModel = [[LoadDetectionModel alloc] init];
    
    __weak LoadDetectionViewController *ws = self;
    
    _conditionDic = [NSMutableDictionary dictionary];
    _listMutableArray = [NSMutableArray array];
//    _curveMutableArray1 = [NSMutableArray array];
//    _curveMutableArray2 = [NSMutableArray array];
    
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
    _collectionView = [[LoadDetectionFilterCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT) collectionViewLayout:flowLayout];
    
    _curveView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYCurveView class]) owner:nil options:nil][0];
    _curveView.translatesAutoresizingMaskIntoConstraints = NO;
    _curveView.hidden = YES;
    [_curveView.rotate buttonClickedHandle:^(UIButton *sender) {
        ws.fullScreenCurveVC.linesMutableArray = ws.curveView.linesMutableArray;
        ws.fullScreenCurveVC.xTitleLab.text = ws.curveView.titleLab.text;
        [ws.navigationController pushViewController:ws.fullScreenCurveVC animated:NO];
        
    }];
    [_curveView.screenBtn buttonClickedHandle:^(UIButton *sender) {
//        ws.collectionView.selectedIndex = 1;
        ws.collectionView.hidden = NO;
    }];
    [self.view addSubview:_curveView];
    
    _fullScreenCurveVC = [[YYCurveViewController alloc] initWithNibName:NSStringFromClass([YYCurveViewController class]) bundle:nil];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_curveView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_curveView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_curveView(==%f)][_tableView]|",SCREEN_WIDTH*4.0f/7.0f] options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_curveView, _tableView)]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getLoadDetectionData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    NSTimeInterval period = 60.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每 period 秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ws.foldSectionModel.idF && ws.listMutableArray.count >0) {
                [ws loadItemWithModel:ws.foldSectionModel andSection:[ws.listMutableArray indexOfObject:ws.foldSectionModel]];
            }
        });
    });
    dispatch_resume(_timer);
    
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.selectedIndex = 1;
    [_collectionView iteminitialization];
    _collectionView.isFold = YES;
    _collectionView.hidden = YES;
    _collectionView.foldHandle = ^(LoadDetectionFilterCollectionView *myCollectionView, BOOL isFold){
        if (isFold) {
            ws.collectionView.hidden = YES;
        } else {
            ws.collectionView.hidden = NO;
        }
    };
    _collectionView.choiceHandle = ^(LoadDetectionFilterCollectionView *myCollectionView, id modelObject, NSInteger idx) {
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
                /*ws.foldSectionModel = nil;
                ws.foldSectionModel = [[LoadDetectionModel alloc] init];*/
                [ws.tableView.mj_header beginRefreshing];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_collectionView];
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
        __block NSInteger currentIdx = 0;
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        [ws.listMutableArray removeAllObjects];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LoadDetectionModel *model = [[LoadDetectionModel alloc] init];
            model.idF = [NSString stringWithFormat:@"%@",obj[@"id"]];
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
            
            NSString *currentIDFString = [NSString stringWithFormat:@"%@",ws.foldSectionModel.idF?ws.foldSectionModel.idF:@""];
            
            if ([ws.conditionDic[@"fifthCondition"] length] > 0) {
                NSString *keyString = ws.conditionDic[@"fifthCondition"]?ws.conditionDic[@"fifthCondition"]:@"";
                if (!([model.device_name rangeOfString:keyString].location == NSNotFound) ||
                    !([model.device_location rangeOfString:keyString].location == NSNotFound)) {
                    [ws.listMutableArray addObject:model];
                    if (ws.listMutableArray.count == 1) {
                        currentIdx = idx;
                    }
                    if (idx== currentIdx && [currentIDFString length] == 0) {
                        ws.foldSectionModel = model;
                        NSInteger contentIndex = [ws.listMutableArray indexOfObject:ws.foldSectionModel];
                        [ws loadItemWithModel:model andSection:contentIndex];
                        [ws loadCurveWithModel:model andSection:contentIndex];
                        model.isFold = YES;
                    } else if ([currentIDFString isEqualToString:model.idF]) {
                        ws.foldSectionModel = model;
                        NSInteger contentIndex = [ws.listMutableArray indexOfObject:ws.foldSectionModel];
                        [ws loadItemWithModel:model andSection:contentIndex];
                        [ws loadCurveWithModel:model andSection:contentIndex];
                        model.isFold = YES;
                    } else {
                        model.isFold = NO;
                    }
                } else {
                    NSLog(@"没有");
                }
            } else {
                if (idx== 0 && [currentIDFString length] == 0) {
                    ws.foldSectionModel = model;
                    [ws loadItemWithModel:model andSection:idx];
                    [ws loadCurveWithModel:model andSection:idx];
                    model.isFold = YES;
                } else if ([currentIDFString isEqualToString:model.idF]) {
                    ws.foldSectionModel = model;
                    [ws loadItemWithModel:model andSection:idx];
                    [ws loadCurveWithModel:model andSection:idx];
                    model.isFold = YES;
                } else {
                    model.isFold = NO;
                }
                [ws.listMutableArray addObject:model];
            }
        }];
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
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
            /*如果设备离线，将区头也改为离线*/
            itemModel.pointState = obj[@"point_state"];
            model.point_value = obj[@"point_value"];
            model.point_type = obj[@"point_type"];
            model.point_unit = obj[@"point_unit"];
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
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"0"} urlString:urlString paraments:param successBlock:^(id object) {
//        [ws.curveMutableArray1 removeAllObjects];
//        [ws.curveMutableArray2 removeAllObjects];
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        NSMutableArray *lines = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * value1Array = [NSArray arrayWithArray:obj];
            NSInteger myIdex = idx;
            NSMutableArray *arrayOne = [NSMutableArray array];
            NSMutableArray *arrayTwo = [NSMutableArray array];
            [value1Array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DoubleGraphModel *model = [[DoubleGraphModel alloc] init];
                model.idf = obj[@"id"];
                model.name = obj[@"name"];
                model.sid = obj[@"sid"];
                model.time = obj[@"time"];
                model.timeLong = obj[@"timeLong"];
                model.value = obj[@"value"];
                if (myIdex==0) {
                    [arrayOne addObject:model];
                } else {
                    [arrayTwo addObject:model];
                }
            }];
            if (myIdex==0) {
                [lines addObject:arrayOne];
            } else {
                [lines addObject:arrayTwo];
            }
        }];
        ws.curveView.linesMutableArray = lines;
        ws.curveView.titleLab.text = itemModel.device_name;
        ws.curveView.hidden = NO;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
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
    headerView.tailImage.image = [UIImage imageNamed:([model.pointState integerValue] == 0) ? @"onLine.png":@"outLine.png"];
    headerView.headerTouchHandle = ^(LoadDatectionHeaderView *dateHeaderView, BOOL isSelected){
        if (isSelected) {
            /*首先关闭原来的选项*/
            NSInteger contentIndex = [ws.listMutableArray indexOfObject:ws.foldSectionModel];
            LoadDetectionModel *currentModel = ws.listMutableArray[contentIndex];
            currentModel.isFold = NO;
            currentModel.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:contentIndex] withRowAnimation:UITableViewRowAnimationNone];
            /*ws.sVC.tTitle = hView.titleLab.text;
            [ws.sVC reloadDataUI];*/
            ws.foldSectionModel = model;
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
    cell.tailImageView.image = [UIImage imageNamed:([modelItem.point_state integerValue]==0)?@"onLine.png":@"outLine.png"];
    return cell;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
