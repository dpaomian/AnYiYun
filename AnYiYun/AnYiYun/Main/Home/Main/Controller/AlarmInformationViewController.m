//
//  AlarmInformationViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "AlarmInformationViewController.h"

@interface AlarmInformationViewController ()

@property (nonatomic, assign) NSInteger   foldSection;

@end

@implementation AlarmInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _foldSection = 0;
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    [self getAlarmInformationData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYAlarmCell class]) bundle:nil] forCellReuseIdentifier:@"YYAlarmCell"];
}

- (void)getAlarmInformationData {
    __weak AlarmInformationViewController *ws = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/supplyPower/alarm",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        [ws.listMutableArray removeAllObjects];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [_listMutableArray count];
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 114.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYAlarmCell" forIndexPath:indexPath];
    cell.btnClickedHandle = ^(YYAlarmCell *yyCell, YYAlarmCellButtonType clickedType){
        switch (clickedType) {
            case YYAlarmCellButtonTypeDeal:
            {
                [MBProgressHUD showSuccess:@"已处理"];
            }
                break;
            case YYAlarmCellButtonTypeRepair:
            {
                [MBProgressHUD showSuccess:@"报修"];
            }
                break;
            case YYAlarmCellButtonTypeCurve:
            {
                [MBProgressHUD showSuccess:@"曲线"];
            }
                break;
            case YYAlarmCellButtonTypeLocation:
            {
                [MBProgressHUD showSuccess:@"定位"];
            }
                break;
                
            default:
                break;
        }
    };
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
