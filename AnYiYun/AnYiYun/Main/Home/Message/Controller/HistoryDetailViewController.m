//
//  HistoryDetailViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/26.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "DBDaoDataBase.h"
#import "HistoryDetailCell.h"
@interface HistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.typeTitleString;
    self.view.backgroundColor = RGB(239, 239, 244);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"clean_icon.png" hightImageName:@"clean_icon.png" target:self action:@selector(rightBarButtonClick)];
    
    [self makeupComponentUI];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[DBDaoDataBase sharedDataBase]updateHistoryMessageReadStatusWithType:self.typeString];
    [[DBDaoDataBase sharedDataBase]updateHistoryGroupMessageNumWithType:self.typeString];
    
    
}

- (void)makeupComponentUI
{
    _datasource = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bgTableView];
    
    [self getUseDataRequest];
}

-(void)rightBarButtonClick
{
    [[DBDaoDataBase sharedDataBase] deleteHistoryMessagesWithType:self.typeString];
    //取数据库中值
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    tempArray = [[DBDaoDataBase sharedDataBase] getAllHistoryMessagesInfoWithType:self.typeString];
    _datasource = [NSMutableArray arrayWithArray:tempArray];
    
    [_bgTableView reloadData];
}

#pragma mark - request
-(void)getUseDataRequest
{
    HistoryMessageModel *itemModel = [[DBDaoDataBase sharedDataBase] getHistoryMessagesGroupInfoWithType:self.typeString];
    
    [_datasource removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/showMessage",BASE_PLAN_URL];
    
    long long time = itemModel.rtime;
    if (time==0)
        {
        time = [BaseHelper getSystemNowTimeLong];
    }
    
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"version":[NSNumber numberWithInteger:time],
                            @"type":self.typeString
                            };
    
    DLog(@"请求地址获取二级 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
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
                     itemModel.uploadtime = [BaseHelper getSystemNowTimeLong];
                     itemModel.type = self.typeString;
                     itemModel.isRead = @"0";
                     [[DBDaoDataBase sharedDataBase] addHistoryMessageInfoTableClassify:itemModel];
                 }
             
             if (self.groupItemModel.num>0)
                 {
                 [[DBDaoDataBase sharedDataBase]addHistoryMessageGroupInfoTableClassify:self.groupItemModel];
                 }
             
                 //取数据库中值
                 NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                 tempArray = [[DBDaoDataBase sharedDataBase] getAllHistoryMessagesInfoWithType:self.typeString];
                 _datasource = [NSMutableArray arrayWithArray:tempArray];
             
                 [_bgTableView reloadData];
             }
         }
         else
         {
             //取数据库中值
             NSMutableArray *tempArray = [[NSMutableArray alloc] init];
             tempArray = [[DBDaoDataBase sharedDataBase] getAllHistoryMessagesInfoWithType:self.typeString];
             _datasource = [NSMutableArray arrayWithArray:tempArray];
             
             [_bgTableView reloadData];
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求失败：%@",error);
             
             //取数据库中值
             NSMutableArray *tempArray = [[NSMutableArray alloc] init];
             tempArray = [[DBDaoDataBase sharedDataBase] getAllHistoryMessagesInfoWithType:self.typeString];
             _datasource = [NSMutableArray arrayWithArray:tempArray];
             
             [_bgTableView reloadData];
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
    HistoryDetailCell  *cell = (HistoryDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[HistoryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_datasource.count>0)
    {
        MessageModel *item = [_datasource objectAtIndex:indexPath.section];
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
