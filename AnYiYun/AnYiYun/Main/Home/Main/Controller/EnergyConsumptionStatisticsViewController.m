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

@end

@implementation EnergyConsumptionStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EnergyConsumptionStatisticsCell class]) bundle:nil] forCellReuseIdentifier:@"EnergyConsumptionStatisticsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    FilterCollectionView *collectionView = [FilterCollectionView shareFilter];
    collectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT);
    collectionView.selectedIndex = 0;
    [collectionView iteminitialization];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.isFold = YES;
    [self.view addSubview:collectionView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:1.0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
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
