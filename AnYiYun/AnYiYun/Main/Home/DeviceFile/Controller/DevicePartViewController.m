//
//  DevicePartViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/28.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "DevicePartViewController.h"
#import "DeviceInfoModel.h"
#import "DevicePartCell.h"

@interface DevicePartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *bgTableView;
@property (nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,strong)NSArray *leftArray;

@end

@implementation DevicePartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(239, 239, 244);
    
    self.title = @"主要部件";
    
    [self makeUI];
}

#pragma mark - request

//判断获取页面信息
-(NSString *)getMiddleRequestValue
{
    NSString *requestString = @"rest/initApp/main_parts";
    if ([self.pushType isEqualToString:@"devicePatrol"])
    {
        requestString = @"rest/devicePatrol/main_parts";
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
             DLog(@"请求结果 = %@",jsonObject);

             if ([jsonObject isKindOfClass:[NSArray class]])
             {
                 NSArray *useArray = (NSArray *)jsonObject;
                 for (int i=0; i<useArray.count; i++)
                 {
                     NSDictionary *useDic = [useArray objectAtIndex:i];
                     DevicePartModel *itemModel = [DevicePartModel mj_objectWithKeyValues:useDic];
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
    
//    _leftArray = @[@"名称",@"型号",@"生产厂商",@"购置时间",@"数量"];
    _leftArray = @[@"名称",@[@"型号：",@"部件类型："],@"生产厂商",@[@"装机量：",@"库存量："],@"上线时间"];
    [self getUseDataRequest];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leftArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSString *cellIdentifier = [NSString stringWithFormat:@"bgTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    DevicePartCell  *cell = (DevicePartCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[DevicePartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
     if (_datasource.count>0)
     {
     DevicePartModel  *itemModel = _datasource[indexPath.section];
     NSString *leftString = _leftArray[indexPath.row];
     NSString *rightString = @"";
     if (indexPath.row==0)
     {
     rightString = itemModel.name;
     }
     else if (indexPath.row==1)
     {
     rightString = itemModel.specification;
     }
     else if (indexPath.row==2)
     {
     rightString = itemModel.manufacturer;
     }
     else if (indexPath.row==3)
     {
     rightString = itemModel.product_time;
     }
     else if (indexPath.row==4)
     {
     rightString = [NSString stringWithFormat:@"%ld",(long)itemModel.number];
     }
     [cell setCellContentWithLeftLabelStr:leftString andRightLabelStr:rightString];
     }
     cell.backgroundColor = [UIColor whiteColor];
     */
    
    if (_datasource.count>0)
    {
        DevicePartModel  *itemModel = _datasource[indexPath.section];
        NSString *rightString = @"";
        if (indexPath.row==0)
        {
            DevicePartCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"DevicePartCell" forIndexPath:indexPath];
            rightString = itemModel.name;
            cell.backgroundColor = [UIColor whiteColor];
            NSString *leftString = _leftArray[indexPath.row];
            [cell setCellContentWithLeftLabelStr:leftString andRightLabelStr:rightString];
            return cell;
        }
        else if (indexPath.row==1)
        {
            YYDevicePartCell  *yyCell = [tableView dequeueReusableCellWithIdentifier:@"YYDevicePartCell" forIndexPath:indexPath];
            NSArray *leftArray = _leftArray[indexPath.row];
            yyCell.titleOne.text = leftArray[0];
            yyCell.titleTwo.text = leftArray[1];
            yyCell.contentOne.text = itemModel.specification;
            yyCell.contentTwo.text = itemModel.kind;
            yyCell.backgroundColor = [UIColor whiteColor];
            return yyCell;
        }
        else if (indexPath.row==2)
        {
            DevicePartCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"DevicePartCell" forIndexPath:indexPath];
            rightString = itemModel.name;
            NSString *leftString = _leftArray[indexPath.row];
            cell.backgroundColor = [UIColor whiteColor];
            [cell setCellContentWithLeftLabelStr:leftString andRightLabelStr:rightString];
            return cell;
        }
        else if (indexPath.row==3)
        {
            YYDevicePartCell  *yyCell = [tableView dequeueReusableCellWithIdentifier:@"YYDevicePartCell" forIndexPath:indexPath];
            NSArray *leftArray = _leftArray[indexPath.row];
            yyCell.titleOne.text = leftArray[0];
            yyCell.titleTwo.text = leftArray[1];
            yyCell.contentOne.text = [NSString stringWithFormat:@"%d",itemModel.inUse];
            yyCell.contentTwo.text = [NSString stringWithFormat:@"%d",itemModel.stock];
            yyCell.backgroundColor = [UIColor whiteColor];
            return yyCell;
        } else {
            DevicePartCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"DevicePartCell" forIndexPath:indexPath];
            rightString = itemModel.product_time;
            NSString *leftString = _leftArray[indexPath.row];
            cell.backgroundColor = [UIColor whiteColor];
            [cell setCellContentWithLeftLabelStr:leftString andRightLabelStr:rightString];
            return cell;
        }
    }else {
        DevicePartCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"DevicePartCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - getter
- (UITableView *)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
        [_bgTableView registerClass:[DevicePartCell class] forCellReuseIdentifier:@"DevicePartCell"];
        [_bgTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYDevicePartCell class]) bundle:nil] forCellReuseIdentifier:@"YYDevicePartCell"];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        _bgTableView.backgroundColor = [UIColor clearColor];
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
