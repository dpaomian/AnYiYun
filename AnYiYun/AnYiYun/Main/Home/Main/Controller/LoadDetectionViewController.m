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

@end

@implementation LoadDetectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak LoadDetectionViewController *ws = self;
    
    _conditionDic = [NSMutableDictionary dictionary];
    _listMutableArray = [NSMutableArray array];
    _constraintsMutableArray = [NSMutableArray array];
    
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
    FilterCollectionView *collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f) collectionViewLayout:flowLayout];
    collectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT);
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
            /* RealtimeMonitoringListModel *model = [[RealtimeMonitoringListModel alloc] init];
             model.idF = obj[@"id"];
             model.device_location = obj[@"device_location"];
             model.device_name = obj[@"device_name"];
             model.kind = obj[@"kind"];
             model.orgId = obj[@"orgId"];
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
             [ws.listMutableArray addObject:model];*/
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 4;
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
    LoadDatectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LoadDatectionHeaderView"];
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
