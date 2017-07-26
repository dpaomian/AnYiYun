//
//  RealtimeMonitoringViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "RealtimeMonitoringViewController.h"
#import "LoadDatectionHeaderView.h"
#import "LoadDatectionCell.h"

@interface RealtimeMonitoringViewController ()

@property (nonatomic, assign) NSInteger   foldSection;

@end

@implementation RealtimeMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foldSection = 0;
    
    [self getRealtimeMonitoringData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _listMutableArray = [NSMutableArray array];
    
    __weak RealtimeMonitoringViewController *ws = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"LoadDatectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionCell class]) bundle:nil] forCellReuseIdentifier:@"LoadDatectionCell"];
    
    _collectionView = [FilterCollectionView shareFilter];
    _collectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f);
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
    [self.view addSubview:_collectionView];    
}

- (void)getRealtimeMonitoringData {
    
    __weak RealtimeMonitoringViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/supplyPower/realTimeMonFirst",BASE_PLAN_URL];
    NSDictionary *conditionDic = @{@"id":@"0",@"name":@"0",@"order":@"0",@"widget":@"0"};
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:conditionDic options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,@"conditions":jsonString};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        DLog(@"%@",object);
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
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
            [ws.listMutableArray addObject:model];
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_listMutableArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == _foldSection ? 4 : 0;
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
    LoadDatectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LoadDatectionHeaderView"];
    RealtimeMonitoringListModel *model = _listMutableArray[section];
    headerView.tailImage.hidden = YES;
    headerView.titleLab.text = model.device_name;
    headerView.contentLab.text = model.device_location;
    headerView.contentLab.font = [UIFont systemFontOfSize:12.0f];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoadDatectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadDatectionCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
