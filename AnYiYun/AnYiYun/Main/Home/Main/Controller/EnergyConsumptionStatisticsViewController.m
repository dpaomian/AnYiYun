//
//  EnergyConsumptionStatisticsViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "EnergyConsumptionStatisticsViewController.h"
#import "FilterCollectionView.h"

@interface EnergyConsumptionStatisticsViewController ()

@property (nonatomic, strong) NSMutableArray *constraintsMutableArray;

@end

@implementation EnergyConsumptionStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _constraintsMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    _listMutableArray = [NSMutableArray array];
    
    __weak EnergyConsumptionStatisticsViewController *ws = self;
    
    [self getEnergyConsumptionStatisticsData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EnergyConsumptionStatisticsCell class]) bundle:nil] forCellReuseIdentifier:@"EnergyConsumptionStatisticsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FilterCollectionView *collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.selectedIndex = 0;
    [collectionView iteminitialization];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
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
                [ws getEnergyConsumptionStatisticsData];
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
                [ws getEnergyConsumptionStatisticsData];
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
                [ws getEnergyConsumptionStatisticsData];
            }
                break;
            case 4:
            {
                UISearchBar * bar = modelObject;
                [ws.conditionDic setObject:bar.text forKey:@"fifthCondition"];
                [ws getEnergyConsumptionStatisticsData];
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
- (void)getEnergyConsumptionStatisticsData {
    __weak EnergyConsumptionStatisticsViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/energyData/energyStatistics",BASE_PLAN_URL];
    
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
            EnergyConsumptionStatisticsModel *model = [[EnergyConsumptionStatisticsModel alloc] init];
            model.dData = obj[@"dData"];
            model.kind = obj[@"kind"];
            model.ldData = obj[@"ldData"];
            model.lmData = obj[@"lmData"];
            model.mData = obj[@"mData"];
            model.name = obj[@"name"];
            model.now = obj[@"now"];
            model.orgId = obj[@"orgId"];
            model.pointState = obj[@"pointState"];
            model.sort = obj[@"sort"];
            model.state = obj[@"state"];
            model.unit = obj[@"unit"];
            [ws.listMutableArray addObject:model];
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listMutableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnergyConsumptionStatisticsModel *model = _listMutableArray[indexPath.row];
    EnergyConsumptionStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnergyConsumptionStatisticsCell" forIndexPath:indexPath];
    cell.allTitleLab.text = model.name;
    cell.tailImageView.image = [UIImage imageNamed:([model.state integerValue]==1)?@"onLine.png":@"outLine.png"];
    cell.allValueLab.text = [NSString stringWithFormat:@"%@ %@",model.now,model.unit];
    cell.yesteDayLab.text = [NSString stringWithFormat:@"%@ %@",model.ldData,model.unit];
    cell.TodayLab.text = [NSString stringWithFormat:@"%@ %@",model.dData,model.unit];
    cell.lastmonthLab.text = [NSString stringWithFormat:@"%@ %@",model.lmData,model.unit];
    cell.monthLab.text = [NSString stringWithFormat:@"%@ %@",model.mData,model.unit];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
