//
//  FireAlarmInformationViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "FireAlarmInformationViewController.h"

@interface FireAlarmInformationViewController ()

@end

@implementation FireAlarmInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    [self getAlarmInformationData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYAlarmCell class]) bundle:nil] forCellReuseIdentifier:@"YYAlarmCell"];
}

- (void)getAlarmInformationData {
    __weak FireAlarmInformationViewController *ws = self;
    /*http://101.201.108.240:18084/Android/*/
//    NSString *urlString = [NSString stringWithFormat:@"%@rest/electricalFire/alarm",BASE_PLAN_URL];
    NSString *urlString = [NSString stringWithFormat:@"%@rest/electricalFire/alarm",@"http://101.201.108.240:18084/Android/"];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        [ws.listMutableArray removeAllObjects];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FireAlarmInformationModel *itemModel = [[FireAlarmInformationModel alloc] init];
            itemModel.idF = obj[@"id"];
            itemModel.content = obj[@"content"];
            itemModel.ctime = obj[@"ctime"];
            itemModel.deviceId = obj[@"deviceId"];
            itemModel.state = obj[@"state"];
            itemModel.time = obj[@"time"];
            itemModel.title = obj[@"title"];
            [ws.listMutableArray addObject:itemModel];
        }];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listMutableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 114.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYAlarmCell" forIndexPath:indexPath];
    FireAlarmInformationModel *modelItem = _listMutableArray[indexPath.row];
    cell.titleLab.text = modelItem.title;
    cell.contentLab.text = modelItem.content;
    cell.timeLab.text = modelItem.time;
    if ([modelItem.state boolValue]) {
        [cell.dealBtn setTitle:@" 已处理" forState:UIControlStateNormal] ;
        [cell.dealBtn setImage:[UIImage imageNamed:@"icon_Round.png"] forState:UIControlStateNormal];
    } else {
        [cell.dealBtn setTitle:@" 未处理" forState:UIControlStateNormal];
        [cell.dealBtn setImage:[UIImage imageNamed:@"icon_Round.png"] forState:UIControlStateNormal];
    }
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
