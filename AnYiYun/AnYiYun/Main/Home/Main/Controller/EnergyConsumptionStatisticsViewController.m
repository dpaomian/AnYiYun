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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    
    NSTimeInterval period = 60.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每 period 秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws getEnergyConsumptionStatisticsData];
        });
    });
    dispatch_resume(_timer);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [_constraintsMutableArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView(==34)]" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:_constraintsMutableArray];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-34-[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getEnergyConsumptionStatisticsData];
    }];
    [self.tableView.mj_header beginRefreshing];
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
            if ([ws.conditionDic[@"fifthCondition"] length] > 0) {
                NSString *keyString = ws.conditionDic[@"fifthCondition"]?ws.conditionDic[@"fifthCondition"]:@"";
                if (!([model.name rangeOfString:keyString].location == NSNotFound) ||
                    !([model.name rangeOfString:keyString].location == NSNotFound)) {
                    [ws.listMutableArray addObject:model];
                } else {
                    DLog(@"没有");
                }
            } else {
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listMutableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
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
    
    cell.yesteDayLab.text = [NSString stringWithFormat:@"昨日电量：%@ %@",model.ldData,model.unit];
    
    NSString *todayCustomStr = [NSString stringWithFormat:@"今日电量：%@ %@",model.dData,model.unit];
    NSRange todayRange = [todayCustomStr rangeOfString:model.dData];
    NSMutableAttributedString *todayStr = [[NSMutableAttributedString alloc] initWithString:todayCustomStr];
    [todayStr addAttribute:NSForegroundColorAttributeName
                     value:[model.dData floatValue] >[model.ldData floatValue]?[UIColor redColor]:UIColorFromRGB(0x0d8eea)
                        range:todayRange];
    [cell.TodayLab setAttributedText:todayStr];
    
    cell.lastmonthLab.text = [NSString stringWithFormat:@"上月电量：%@ %@",model.lmData,model.unit];
    
    NSString *monthCustomStr = [NSString stringWithFormat:@"当月电量：%@ %@",model.mData,model.unit];
    NSRange monthRange = [monthCustomStr rangeOfString:model.mData];
    NSMutableAttributedString *monthStr = [[NSMutableAttributedString alloc] initWithString:monthCustomStr];
    [monthStr addAttribute:NSForegroundColorAttributeName
                     value:[model.mData floatValue] >[model.lmData floatValue]?[UIColor redColor]:UIColorFromRGB(0x0d8eea)
                     range:monthRange];
    [cell.monthLab setAttributedText:monthStr];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
