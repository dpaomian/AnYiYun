//
//  LoadDetectionViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoadDetectionViewController.h"

@interface LoadDetectionViewController ()

@property (nonatomic, assign) NSInteger   foldSection;

@end

@implementation LoadDetectionViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foldSection = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"LoadDatectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadDatectionCell class]) bundle:nil] forCellReuseIdentifier:@"LoadDatectionCell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
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
