//
//  FireAlarmInformationViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "FireAlarmInformationViewController.h"
#import "DoubleGraphModel.h"

@interface FireAlarmInformationViewController ()

@end

@implementation FireAlarmInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak FireAlarmInformationViewController *ws = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"getMessageIsRead" object:nil];
    
    _listMutableArray = [NSMutableArray array];
    _conditionDic = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYAlarmCell class]) bundle:nil] forCellReuseIdentifier:@"YYAlarmCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getAlarmInformationData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    _fullScreenCurveVC = [[YYCurveViewController alloc] initWithNibName:NSStringFromClass([YYCurveViewController class]) bundle:nil];
}

//刷新消息界面
-(void)refresh:(NSNotification *)notify
{
    NSString *messageNotify  = notify.object;
    if ([messageNotify boolValue]==YES) {
        //接收到推送 有新消息
        [self getAlarmInformationData];
    }
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
            itemModel.pointId = obj[@"pointId"];
            itemModel.result = obj[@"result"];
            itemModel.userId = obj[@"userId"];
            itemModel.userName = obj[@"userName"];
            [ws.listMutableArray addObject:itemModel];
        }];
        ws.noDataView.hidden = ws.listMutableArray.count>0;
        ws.tableView.separatorStyle = (!(ws.listMutableArray.count>0))?UITableViewCellSeparatorStyleNone:UITableViewCellSeparatorStyleSingleLine;
        [self.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"请求失败"];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listMutableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 114.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak FireAlarmInformationViewController *ws = self;
    
    YYAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYAlarmCell" forIndexPath:indexPath];
    FireAlarmInformationModel *modelItem = _listMutableArray[indexPath.row];
    if ([modelItem.pointId isEqual:[NSNull null]] || modelItem.pointId == nil) {
        cell.curveBtn.userInteractionEnabled = NO;
        cell.curveBtn.selected = YES;
    } else {
        cell.curveBtn.userInteractionEnabled = YES;
        cell.curveBtn.selected = NO;
    }
    cell.titleLab.text = modelItem.title;
    cell.contentLab.text = modelItem.content;
    cell.timeLab.text = [modelItem.time substringFromIndex:5];
    if ([modelItem.state boolValue]) {
        [cell.dealBtn setTitle:@" 已处理" forState:UIControlStateNormal] ;
        [cell.dealBtn setImage:[UIImage imageNamed:@"icon_Round.png"] forState:UIControlStateNormal];
    } else {
        [cell.dealBtn setTitle:@" 已处理" forState:UIControlStateNormal];
        [cell.dealBtn setImage:[UIImage imageNamed:@"icon_Round.png"] forState:UIControlStateNormal];
    }
    cell.btnClickedHandle = ^(YYAlarmCell *yyCell, YYAlarmCellButtonType clickedType){
        switch (clickedType) {
            case YYAlarmCellButtonTypeDeal:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要选择\"已处理\"么？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
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
                         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                         BOOL dealState  = [string boolValue];
                     if (dealState==NO)
                         {
                         [BaseHelper waringInfo:@"处理失败"];
                         } else {
                             [MBProgressHUD showSuccess:@"已处理成功"];
                         }
                         [ws.tableView.mj_header beginRefreshing];
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
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
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
                         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                         BOOL dealState  = [string boolValue];
                         if (dealState==NO)
                         {
                             [BaseHelper waringInfo:@"提交失败"];
                         } else {
                              
                             [MBProgressHUD showSuccess:@"报修成功"];
                         }
                         [ws.tableView.mj_header beginRefreshing];
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
                [ws loadCurveWithModel:modelItem andIndex:indexPath.row];
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

- (void)loadCurveWithModel:(FireAlarmInformationModel *)itemModel andIndex:(NSInteger)index {
    __weak FireAlarmInformationViewController *ws = self;
    NSString *urlString = [NSString stringWithFormat:@"%@rest/initApp/showAlarm_graph",BASE_PLAN_URL];
    NSDictionary *param = @{@"bugId":itemModel.idF};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"0"} urlString:urlString paraments:param successBlock:^(id object) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:object];
        NSMutableArray *lines = [NSMutableArray array];
        
        NSMutableArray *arrayOne = [NSMutableArray array];
        NSMutableArray *arrayTwo = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DoubleGraphModel *model = [[DoubleGraphModel alloc] init];
            model.idf = obj[@"id"];
            model.name = obj[@"name"];
            model.sid = obj[@"sid"];
            model.time = obj[@"time"];
            model.timeLong = obj[@"timeLong"];
            model.value = obj[@"value"];
        }];
        [lines addObject:arrayOne];
        [lines addObject:arrayTwo];
        ws.fullScreenCurveVC.linesMutableArray = lines;
        ws.fullScreenCurveVC.xTitleLab.text = itemModel.content;
        [ws.navigationController pushViewController:ws.fullScreenCurveVC animated:NO];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"获取曲线失败"];
    } progress:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
