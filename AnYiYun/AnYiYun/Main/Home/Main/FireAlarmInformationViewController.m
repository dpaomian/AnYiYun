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
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    [self getAlarmInformationData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYAlarmCell class]) bundle:nil] forCellReuseIdentifier:@"YYAlarmCell"];
}

- (void)getAlarmInformationData {
    __weak FireAlarmInformationViewController *ws = self;
    /*http://101.201.108.240:18084/Android/*/
    NSString *urlString = [NSString stringWithFormat:@"%@rest/electricalFire/alarm",BASE_PLAN_URL];
//    NSString *urlString = [NSString stringWithFormat:@"%@rest/electricalFire/alarm",@"http:101.201.108.240:18084/Android/"];
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
    
    __weak FireAlarmInformationViewController *ws = self;
    
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
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要选择\"已处理\"么？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urlString = [NSString stringWithFormat:@"%@rest/process/bugP",BASE_PLAN_URL];
                    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                                            @"bugId":modelItem.idF,
                                            @"type":@"1"};
                    
                    [MBProgressHUD showMessage:@"提交中..."];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    [manager GET:urlString
                      parameters:param
                        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                     {
                         [MBProgressHUD hideHUD];
                         BOOL dealState = (BOOL)responseObject;
                         if (dealState==NO)
                         {
                             [BaseHelper waringInfo:@"提交失败"];
                         } else {
                             [MBProgressHUD showSuccess:@"报修成功"];
                         }
                     }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             [MBProgressHUD hideHUD];
                         }];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [ws presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case YYAlarmCellButtonTypeRepair:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要选择\"提交检修\"么？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urlString = [NSString stringWithFormat:@"%@rest/process/bugS",BASE_PLAN_URL];
                    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                                            @"bugId":modelItem.idF,
                                            @"type":@"1"};
                    
                    [MBProgressHUD showMessage:@"提交中..."];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    [manager GET:urlString
                      parameters:param
                        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                     {
                         [MBProgressHUD hideHUD];
                         BOOL dealState = (BOOL)responseObject;
                         if (dealState==NO)
                         {
                             [BaseHelper waringInfo:@"提交失败"];
                         } else {
                             [MBProgressHUD showSuccess:@"报修成功"];
                         }
                     }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             [MBProgressHUD hideHUD];
                         }];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [ws presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case YYAlarmCellButtonTypeCurve:
            {
                [MBProgressHUD showSuccess:@"曲线"];
            }
                break;
            case YYAlarmCellButtonTypeLocation:
            {
                LocationViewController *locationVC = [[LocationViewController alloc]init];
                locationVC.deviceIdString = modelItem.deviceId;
                locationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:locationVC animated:YES];
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
