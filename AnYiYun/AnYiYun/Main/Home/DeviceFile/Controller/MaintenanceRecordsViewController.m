//
//  MaintenanceRecordsViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/28.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MaintenanceRecordsViewController.h"
#import "MessageModel.h"
#import "RecordCell.h"

@interface MaintenanceRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isGetMore;
}
@property (nonatomic,strong)UITableView *bgTableView;
@property (nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,strong)UIButton  *footBtn;

@end

@implementation MaintenanceRecordsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"保养记录";
    
    isGetMore = NO;
    [self makeUI];
}

-(void)footBtnClick
{
    isGetMore = YES;
    [self getUseDataRequest];
    _footBtn.hidden = YES;
}

#pragma mark - request

//判断获取页面信息
-(NSString *)getMiddleRequestValue
{
    NSString *requestString = @"rest/initApp/upkeepRec";
    if ([self.pushType isEqualToString:@"devicePatrol"])
    {
        requestString = @"rest/devicePatrol/upkeepRec";
    }
    return requestString;
}

-(void)getUseDataRequest
{
    [_datasource removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,[self getMiddleRequestValue]];
    if (isGetMore==YES)
    {
        urlString = [NSString stringWithFormat:@"%@%@More",BASE_PLAN_URL,[self getMiddleRequestValue]];
    }
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
                     MessageModel *itemModel = [[MessageModel alloc]initWithDictionary:useDic];
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
    self.view.backgroundColor = RGB(239, 239, 244);
    
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
    RecordCell  *cell = (RecordCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_datasource.count>0)
    {
        MessageModel  *itemModel = _datasource[indexPath.row];
        [cell setCellContentWithModel:itemModel];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - getter
- (UITableView *)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        _bgTableView.backgroundColor = [UIColor clearColor];
        _bgTableView.tableFooterView = self.footBtn;
    }
    return _bgTableView;
}

- (UIButton *)footBtn
{
    if (!_footBtn) {
        _footBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _footBtn.backgroundColor = [UIColor clearColor];
        [_footBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [_footBtn setTitleColor:kAppTitleGrayColor forState:UIControlStateNormal];
        _footBtn.titleLabel.font = SYSFONT_(14);
        [_footBtn addTarget:self action:@selector(footBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footBtn;
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
