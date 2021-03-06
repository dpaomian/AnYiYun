//
//  DeviceInfoViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "DeviceInfoModel.h"
#import "DeviceInfoCell.h"
#import "HJCActionSheet.h"
@interface DeviceInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HJCActionSheetDelegate>

@property (nonatomic,strong)UITableView *bgTableView;
@property (nonatomic,strong)NSMutableArray *datasource;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"基本信息";
    [self makeUI];
    
}

#pragma mark - request

-(void)getChangeDataWithType:(NSInteger)type
{
    if (![BaseHelper checkNetworkStatus])
        {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/initApp/change_ds"];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"deviceId":self.deviceIdString,
                            @"state":[NSString stringWithFormat:@"%ld",(long)type]};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         BOOL isHaveAlertMessage  = [string boolValue];

     if (isHaveAlertMessage==YES)
         {
         [self getUseDataRequest];
     }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
         }];
    
}

-(void)getDataWithModel:(DeviceInfoModel *)info
{
    NSString *statesString = @"";
    if (info.device_state==0)
        {
        statesString = @"生产中";
        }
    else if (info.device_state==1)
        {
        statesString = @"运行中";
        }
    else if (info.device_state==2)
        {
        statesString = @"检修中";
        }
    NSArray *dicArray = @[@{@"设备名称":[BaseHelper isSpaceString:info.sign andReplace:@""]},
                          @{@"设备编号":[NSString stringWithFormat:@"%@",info.assetId]},
                          @{@"规格型号":[BaseHelper isSpaceString:info.modle andReplace:@""]},
                          @{@"设备类别":[BaseHelper isSpaceString:info.kindValue andReplace:@""]},
                          @{@"生产厂商":[BaseHelper isSpaceString:info.makerName andReplace:@""]},
                          @{@"供应厂商":[BaseHelper isSpaceString:info.sellerName andReplace:@""]},
                          @{@"购置时间":[BaseHelper isSpaceString:info.purchaseTime andReplace:@""]},
                          @{@"购置方式":[BaseHelper isSpaceString:info.purchaseMethod andReplace:@""]},
                          @{@"资产负责":[BaseHelper isSpaceString:info.aManagerName andReplace:@""]},
                          @{@"所属部门":[BaseHelper isSpaceString:info.orgName andReplace:@""]},
                          @{@"安装位置":[BaseHelper isSpaceString:info.installationSite andReplace:@""]},
                          @{@"坐标":[BaseHelper isSpaceString:info.position andReplace:@""]},
                          /*@{@"资产原值":[NSString stringWithFormat:@"%ld",(long)info.originalValue]},
                          @{@"资产净值":[NSString stringWithFormat:@"%ld",(long)info.netValue]},
                          @{@"报废年限":[NSString stringWithFormat:@"%ld",(long)info.discarded]},
                          @{@"距离报废":@""},
                          @{@"累计运行":[BaseHelper isSpaceString:info.func_day andReplace:@""]},*/
                          @{@"设备状态":statesString},
                          ];
    _datasource = [NSMutableArray arrayWithArray:dicArray];
    [_bgTableView reloadData];
}

//判断获取页面信息
-(NSString *)getMiddleRequestValue
{
    NSString *requestString = @"rest/initApp/basic_info";
    return requestString;
}

-(void)getUseDataRequest
{
    if (![BaseHelper checkNetworkStatus])
    {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,[self getMiddleRequestValue]];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"deviceId":self.deviceIdString};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *resuleDic = (NSDictionary *)responseObject;
         DeviceInfoModel *info = [DeviceInfoModel mj_objectWithKeyValues:resuleDic];

         [self getDataWithModel:info];
         
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
         }];

}

-(void)makeUI
{
    _datasource = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bgTableView];
    
    [self getUseDataRequest];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"bgTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    DeviceInfoCell  *cell = (DeviceInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[DeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_datasource.count>0)
    {
        NSDictionary  *dataDic = _datasource[indexPath.row];
        
        NSString *leftString = [[dataDic allKeys] objectAtIndex:0];
        NSString *rightString = [[dataDic allValues] objectAtIndex:0];
        
        [cell setCellContentWithLeftLabelStr:leftString andRightLabelStr:rightString];
    if (indexPath.row==_datasource.count-1)
        {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
        {
        cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==_datasource.count-1)
        {
         HJCActionSheet *actionSheet = [[HJCActionSheet alloc] initWithDelegate:self andMessageTitle:nil CancelTitle:@"取消" OtherTitles:@"生产中", @"运行中", @"检修中", nil];
        [actionSheet show];
    }
    
}

#pragma mark - HJCActionSheetDelegate

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex>0)
        {
        [self getChangeDataWithType:buttonIndex-1];
    }
}

#pragma mark - getter
- (UITableView *)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, kScreen_Height - 64 - 10) style:UITableViewStylePlain];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        _bgTableView.backgroundColor = [UIColor clearColor];
        _bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _bgTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
