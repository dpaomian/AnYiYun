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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _constraintsMutableArray = [NSMutableArray array];
    
    __weak EnergyConsumptionStatisticsViewController *ws = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EnergyConsumptionStatisticsCell class]) bundle:nil] forCellReuseIdentifier:@"EnergyConsumptionStatisticsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FilterCollectionView *collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f) collectionViewLayout:flowLayout];
    collectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT);
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
    [self.view addSubview:collectionView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [_constraintsMutableArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView(==34)]" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:_constraintsMutableArray];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-34-[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnergyConsumptionStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnergyConsumptionStatisticsCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
