//
//  HistoryMessageViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/26.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HistoryMessageViewController.h"
#import "DBDaoDataBase.h"
#import "HistoryMessageCell.h"
#import "HistoryDetailViewController.h"

@interface HistoryMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation HistoryMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.title = @"历史消息";
    
    self.view.backgroundColor = RGB(239, 239, 244);
    [self makeupComponentUI];
    
}

- (void)makeupComponentUI
{
    _datasource = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bgTableView];
    
    [self getUseDataRequest];
}


#pragma mark - request
-(void)getUseDataRequest
{
    [_datasource removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/messageGroup",BASE_PLAN_URL];

    long long useTime = [BaseHelper getSystemNowTimeLong]-3600*24*10;
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"version":[NSString stringWithFormat:@"%lld", useTime]};
    
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
                     HistoryMessageModel *itemModel = [HistoryMessageModel mj_objectWithKeyValues:useDic];
                     
                     [[DBDaoDataBase sharedDataBase]addHistoryMessageGroupInfoTableClassify:itemModel];
                     
                     NSMutableArray *tempArray = [[DBDaoDataBase sharedDataBase]getAllHistoryMessagesInfoWithType:[NSString stringWithFormat:@"%ld",(long)itemModel.type]];
                     
                     if (itemModel.num>0||tempArray.count>0)
                     {
                         [_datasource addObject:itemModel];
                     }
                 }
                 [_bgTableView reloadData];
             }
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
         }];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"bgTableView_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    HistoryMessageCell  *cell = (HistoryMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[HistoryMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_datasource.count>0)
    {
        HistoryMessageModel *item = [_datasource objectAtIndex:indexPath.section];
        [cell setCellContentWithModel:item];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HistoryMessageModel *item = [_datasource objectAtIndex:indexPath.section];
    HistoryDetailViewController *vc = [[HistoryDetailViewController alloc]init];
    vc.typeString = [NSString stringWithFormat:@"%ld",(long)item.type];
    vc.typeTitleString = item.typeName;
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
