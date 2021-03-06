//
//  FirePowerSupplyRealtimeMonitoringViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "FirePowerSupplyRealtimeMonitoringViewController.h"
#import "LoadDatectionHeaderView.h"

@interface FirePowerSupplyRealtimeMonitoringViewController ()

/*!记录被展开的区*/
@property (nonatomic, strong) RealtimeMonitoringListModel   *foldSectionModel;

@end

@implementation FirePowerSupplyRealtimeMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _foldSectionModel = [[RealtimeMonitoringListModel alloc] init];
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    
    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"LoadDatectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RealtimeMonitoringChildCell class]) bundle:nil] forCellReuseIdentifier:@"RealtimeMonitoringChildCell"];
    
    
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
    
    _fullScreenCurveVC = [[YYCurveViewController alloc] initWithNibName:NSStringFromClass([YYCurveViewController class]) bundle:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getRealtimeMonitoringData];
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
}

- (void)getRealtimeMonitoringData {
    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/firePower/realTimeMonFirst",BASE_PLAN_URL];
    
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
            RealtimeMonitoringListModel *model = [[RealtimeMonitoringListModel alloc] init];
            model.idF = [NSString stringWithFormat:@"%@",obj[@"id"]];
            model.device_location = obj[@"device_location"];
            model.device_name = obj[@"device_name"];
            model.kind = obj[@"kind"];
            model.orgId = obj[@"orgId"];
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
                    if (idx== 0 && [currentIDFString length] == 0) {
                        ws.foldSectionModel = model;
                        [ws loadItemWithModel:model andSection:[ws.listMutableArray indexOfObject:ws.foldSectionModel]];
                        model.isFold = YES;
                    } else if ([currentIDFString isEqualToString:model.idF]) {
                        ws.foldSectionModel = model;
                        [ws loadItemWithModel:model andSection:[ws.listMutableArray indexOfObject:ws.foldSectionModel]];
                        model.isFold = YES;
                    }else {
                        model.isFold = NO;
                    }
                } else {
                    NSLog(@"没有");
                }
            } else {
                if (idx== 0 && [currentIDFString length] == 0) {
                    ws.foldSectionModel = model;
                    [ws loadItemWithModel:model andSection:idx];
                    model.isFold = YES;
                } else if ([currentIDFString isEqualToString:model.idF]) {
                    ws.foldSectionModel = model;
                    [ws loadItemWithModel:model andSection:idx];
                    model.isFold = YES;
                } else {
                    model.isFold = NO;
                }
                [ws.listMutableArray addObject:model];
            }
        }];
        if (![ws.listMutableArray containsObject:ws.foldSectionModel]) {
            [ws.listMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RealtimeMonitoringListModel *model = obj;
                ws.foldSectionModel = model;
                [ws loadItemWithModel:model andSection:idx];
                model.isFold = YES;
                *stop = YES;
            }];
        }
        [self.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

- (void)loadCurveWithModel:(RealtimeMonitoringListModelList *)itemModel andSection:(NSInteger)section {
    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/doubleGraph",BASE_PLAN_URL];
    if ([itemModel.point_type integerValue] == 103) {
        urlString = [NSString stringWithFormat:@"%@rest/busiData/doubleGraph",BASE_PLAN_URL];
    } else if ([itemModel.point_type integerValue] == 101) {
        urlString = [NSString stringWithFormat:@"%@rest/busiData/doubleGraph",BASE_PLAN_URL];
    } else if ([itemModel.point_type integerValue] == 104) {
        urlString = [NSString stringWithFormat:@"%@rest/busiData/singleGraph",BASE_PLAN_URL];
    } else if ([itemModel.point_type integerValue] == 105) {
        urlString = [NSString stringWithFormat:@"%@rest/busiData/singleGraph",BASE_PLAN_URL];
    } else {};
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"pointId":itemModel.idF,@"type":itemModel.point_type};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"0"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        NSMutableArray *lines = [NSMutableArray array];
        
        NSMutableArray *arrayOne = [NSMutableArray array];
        NSMutableArray *arrayTwo = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([itemModel.point_type integerValue] == 104 ||
                [itemModel.point_type integerValue] == 105) {
                DoubleGraphModel *model = [[DoubleGraphModel alloc] init];
                model.idf = obj[@"id"];
                model.name = obj[@"name"];
                model.sid = obj[@"sid"];
                model.time = obj[@"time"];
                model.timeLong = obj[@"timeLong"];
                model.value = obj[@"value"];
                [arrayOne addObject:model];
            } else {
                NSArray * value1Array = [NSArray arrayWithArray:obj];
                NSInteger myIdex = idx;
                
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
            }
        }];
        [lines addObject:arrayOne];
        [lines addObject:arrayTwo];
        
        ws.fullScreenCurveVC.linesMutableArray = lines;
        ws.fullScreenCurveVC.xTitleLab.text = itemModel.point_name;
        if ([itemModel.point_type integerValue] == 103) {
            ws.fullScreenCurveVC.xTimeLab.text = @"时间(小时.分钟)";
            ws.fullScreenCurveVC.yTitleLab.text = @"负荷(KW)";
            ws.fullScreenCurveVC.todayLab.hidden = NO;
            ws.fullScreenCurveVC.yestodayLab.hidden = NO;
        } else if ([itemModel.point_type integerValue] == 101) {
            ws.fullScreenCurveVC.xTimeLab.text = @"时间(小时.分钟)";
            ws.fullScreenCurveVC.yTitleLab.text = @"电流(A)";
            ws.fullScreenCurveVC.todayLab.hidden = NO;
            ws.fullScreenCurveVC.yestodayLab.hidden = NO;
        } else if ([itemModel.point_type integerValue] == 104) {
            ws.fullScreenCurveVC.xTimeLab.text = @"时间(日.小时)";
            ws.fullScreenCurveVC.yTitleLab.text = @"漏电(A)";
            ws.fullScreenCurveVC.todayLab.hidden = YES;
            ws.fullScreenCurveVC.yestodayLab.hidden = YES;
        } else if ([itemModel.point_type integerValue] == 105) {
            ws.fullScreenCurveVC.xTimeLab.text = @"时间(日.小时)";
            ws.fullScreenCurveVC.yTitleLab.text = @"温度(ºC)";
            ws.fullScreenCurveVC.todayLab.hidden = YES;
            ws.fullScreenCurveVC.yestodayLab.hidden = YES;
        } else {
            ws.fullScreenCurveVC.xTimeLab.text = @"时间(小时.分钟)";
            ws.fullScreenCurveVC.yTitleLab.text = @"电流(A)";
            ws.fullScreenCurveVC.todayLab.hidden = NO;
            ws.fullScreenCurveVC.yestodayLab.hidden = NO;
        };
        [ws.navigationController pushViewController:ws.fullScreenCurveVC animated:NO];
        /*ws.curveView.linesMutableArray = lines;
         ws.curveView.hidden = NO;*/
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
    return 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
    
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
            NSInteger contentIndex = [ws.listMutableArray indexOfObject:ws.foldSectionModel];
            RealtimeMonitoringListModel *currentModel = ws.listMutableArray[contentIndex];
            currentModel.isFold = NO;
            currentModel.itemsMutableArray = [@[] mutableCopy];
            [ws.tableView reloadSections:[NSIndexSet indexSetWithIndex:contentIndex] withRowAnimation:UITableViewRowAnimationNone];
            
            ws.foldSectionModel = model;
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
    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/firePower/realTimeMonSecond",BASE_PLAN_URL];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
    RealtimeMonitoringListModelList *modelItem = model.itemsMutableArray[indexPath.row];
    if ([modelItem.point_type integerValue] == 201) {
        RealtimeMonitoringChildSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RealtimeMonitoringChildSwitchCell" forIndexPath:indexPath];
        cell.titleLab.text = modelItem.point_name;
        cell.tailImageView.image = [UIImage imageNamed:([modelItem.point_state integerValue]==0)?@"onLine.png":@"outLine.png"];
        cell.yySwitch.on = [modelItem.point_value boolValue];
        
        if (modelItem.displayIcon) {
            cell.lineIconBtn.userInteractionEnabled = YES;
            [cell.lineIconBtn setImage:[UIImage imageNamed:@"Polyline.png"] forState:UIControlStateNormal];
        } else {
            cell.lineIconBtn.userInteractionEnabled = NO;
            [cell.lineIconBtn setImage:nil forState:UIControlStateNormal];
        }
        [cell.yySwitch switchChangeHandle:^(UISwitch *sender) {
            YYPasswordViewController *inputPswVC = [[YYPasswordViewController alloc] initWithNibName:NSStringFromClass([YYPasswordViewController class]) bundle:nil];
            inputPswVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            inputPswVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            inputPswVC.model = modelItem;
            [ws presentViewController:inputPswVC animated:YES completion:^{
                
            }];
        }];
        [cell.lineIconBtn buttonClickedHandle:^(UIButton *sender) {
            [ws loadCurveWithModel:modelItem andSection:indexPath.section];
        }];
        return cell;
    } else {
        RealtimeMonitoringChildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RealtimeMonitoringChildCell" forIndexPath:indexPath];
        cell.titleLab.text = modelItem.point_name;
        cell.tailImageView.image = [UIImage imageNamed:([modelItem.point_state integerValue]==0)?@"onLine.png":@"outLine.png"];
        [cell.contentBtn setTitle:[NSString stringWithFormat:@"%@  %@",modelItem.point_value,modelItem.point_unit] forState:UIControlStateNormal];
        
        if (modelItem.displayIcon) {
            cell.lineIconBtn.userInteractionEnabled = YES;
            cell.contentBtn.userInteractionEnabled = YES;
            [cell.lineIconBtn setImage:[UIImage imageNamed:@"Polyline.png"] forState:UIControlStateNormal];
        } else {
            cell.lineIconBtn.userInteractionEnabled = NO;
            cell.contentBtn.userInteractionEnabled = NO;
            [cell.lineIconBtn setImage:nil forState:UIControlStateNormal];
        }
        [cell.contentBtn buttonClickedHandle:^(UIButton *sender) {
            [ws loadCurveWithModel:modelItem andSection:indexPath.section];
        }];
        [cell.lineIconBtn buttonClickedHandle:^(UIButton *sender) {
            [ws loadCurveWithModel:modelItem andSection:indexPath.section];
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
    RealtimeMonitoringListModelList *modelItem = model.itemsMutableArray[indexPath.row];
    [self loadCurveWithModel:modelItem andSection:indexPath.section];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak FirePowerSupplyRealtimeMonitoringViewController *ws = self;
//    RealtimeMonitoringChildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RealtimeMonitoringChildCell" forIndexPath:indexPath];
//    RealtimeMonitoringListModel *model = _listMutableArray[indexPath.section];
//    RealtimeMonitoringListModelList *modelItem = model.itemsMutableArray[indexPath.row];
//    cell.titleLab.text = modelItem.point_name;
//    cell.tailImageView.image = [UIImage imageNamed:([modelItem.point_state integerValue]==0)?@"onLine.png":@"outLine.png"];
//    [cell.contentBtn setTitle:[NSString stringWithFormat:@"%@  %@",modelItem.point_value,modelItem.point_unit] forState:UIControlStateNormal];
//    if (modelItem.displayIcon) {
//        cell.lineIconBtn.userInteractionEnabled = YES;
//        cell.contentBtn.userInteractionEnabled = YES;
//        [cell.lineIconBtn setImage:[UIImage imageNamed:@"Polyline.png"] forState:UIControlStateNormal];
//    } else {
//        cell.lineIconBtn.userInteractionEnabled = NO;
//        cell.contentBtn.userInteractionEnabled = NO;
//        [cell.lineIconBtn setImage:nil forState:UIControlStateNormal];
//    }
//    [cell.contentBtn buttonClickedHandle:^(UIButton *sender) {
//        [ws loadCurveWithModel:modelItem andSection:indexPath.section];
//    }];
//    [cell.lineIconBtn buttonClickedHandle:^(UIButton *sender) {
//        [ws loadCurveWithModel:modelItem andSection:indexPath.section];
//    }];
//    return cell;
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
