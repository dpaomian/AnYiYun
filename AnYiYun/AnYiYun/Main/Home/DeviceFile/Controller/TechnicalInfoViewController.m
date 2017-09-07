//
//  TechnicalInfoViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "TechnicalInfoViewController.h"

#import "DeviceInfoModel.h"

#import "PublicWebViewController.h"

@interface TechnicalInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *bgTableView;
@property (nonatomic,strong)NSMutableArray *datasource;

@end

@implementation TechnicalInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"技术资料";
    
    [self makeUI];
}

#pragma mark - request

//判断获取页面信息
-(NSString *)getMiddleRequestValue
{
    NSString *requestString = @"rest/initApp/device_doc";
    if ([self.pushType isEqualToString:@"devicePatrol"])
    {
        requestString = @"rest/devicePatrol/device_doc";
    }
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
         if ([responseObject isKindOfClass:[NSData class]])
         {
             id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             
             if ([jsonObject isKindOfClass:[NSArray class]])
             {
                 NSArray *useArray = (NSArray *)jsonObject;
                 for (int i=0; i<useArray.count; i++)
                 {
                     NSDictionary *useDic = [useArray objectAtIndex:i];
                     DeviceDocModel *itemModel = [DeviceDocModel mj_objectWithKeyValues:useDic];
                     [_datasource addObject:itemModel];
                 }
                 [_bgTableView reloadData];
             }
         }
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
    UITableViewCell  *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_datasource.count>0)
    {
        DeviceDocModel *itemModel = [_datasource objectAtIndex:indexPath.row];
        cell.textLabel.text = itemModel.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = kAppTitleBlackColor;
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceDocModel *item = [_datasource objectAtIndex:indexPath.row];
    
    PublicWebViewController *vc = [[PublicWebViewController alloc]init];
    vc.myUrl = item.url;
    vc.titleStr = item.name;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - getter
- (UITableView *)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        _bgTableView.backgroundColor = [UIColor clearColor];
        _bgTableView.tableFooterView = [[UIView alloc]init];
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
