    //
    //  HomeMainViewController.m
    //  AnYiYun
    //
    //  Created by wwr on 2017/7/19.
    //  Copyright © 2017年 wwr. All rights reserved.
    //

#import "HomeMainViewController.h"
#import "SDCycleScrollView.h"
#import "HomeModel.h"
#import "PublicWebViewController.h"
#import "HomeAdverCell.h"
#import "HomeMessageCell.h"
#import "MessageViewController.h"


/**广告图高*/
#define AD_Height (kScreen_Width/2)
@interface HomeMainViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray  *adverArray;
    BOOL            isHaveAlertMessage;
    NSString        *safeTimeString;//安全运行时间
}
/**广告图*/
@property (nonatomic,strong)UIView                     *adBgView;
@property (nonatomic,strong)UIView                     *tableHeadView;
@property (nonatomic,strong)SDCycleScrollView          *adView;
@property (nonatomic,strong)UITableView     *bpTableView;//内容表格

@end

@implementation HomeMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"首页";
    [self setLeftBarItem];
        //广告
    [self getPictureRequestAction];
        //公告
        //[self getNotifyRequestAction];
        //菜单
    [self getMenuRequestAction];
    
        //消息中心
    [self getMessageRequestAction];
    [self getSafetyRequestAction];
        //推广
    [self getAdverRequestAction];
    
    [self makeView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //刷新是否有未读消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMessageIsRead" object:@""];
}

-(void)setLeftBarItem {
    UIButton *anYiYunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [anYiYunBtn setImage:[UIImage imageNamed:@"logo_white.png"] forState:UIControlStateNormal];
    [anYiYunBtn setTitle:@" 安易云" forState:UIControlStateNormal];
    [anYiYunBtn sizeToFit];
    [anYiYunBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:anYiYunBtn];
    self.navigationItem.titleView = [UIView new];
}

-(void)moduleBtnClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        EnergyManagementViewController *energyVC = [[EnergyManagementViewController alloc]init];
        energyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:energyVC animated:YES];
    } else if (sender.tag == 101){
        PowerDistributionTabBarRootViewController *powerRootVC = [[PowerDistributionTabBarRootViewController alloc]init];
        powerRootVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:powerRootVC animated:YES];
    }  else if (sender.tag == 102){
        ElectricalFireTabBarRootViewController *fireVC = [[ElectricalFireTabBarRootViewController alloc]init];
        fireVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fireVC animated:YES];
    } else {
        FirePowerSupplyTabBarRootViewController *allApplicationVC = [[FirePowerSupplyTabBarRootViewController alloc]init];
        allApplicationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:allApplicationVC animated:YES];
    }
}

#pragma mark - 设置View

-(void)makeView
{
    [self.view addSubview:self.bpTableView];
    
    NSArray *imageArray = @[@"home_icon_n.png",@"home_icon_g.png",@"home_icon_d.png",@"all_icon_5.png"];
    NSArray *titleArray = @[@"能源管理",@"供配电",@"电气火灾",@"消防电源"];
    
    CGFloat btnWidth = (kScreen_Width-3*1)/titleArray.count;
    CGFloat btnHeight = (kScreen_Width-3*1)/4;
    for (int i=0; i<titleArray.count; i++)
        {
        CGFloat xx = i%titleArray.count*(btnWidth+1);
        CGFloat yy = i/4*btnHeight+AD_Height;
        
        UIButton *useBtn = [[UIButton alloc]initWithFrame: CGRectMake(xx, yy, btnWidth, btnHeight)];
        useBtn.backgroundColor = [UIColor whiteColor];
        
        UIImageView  *itemImgView = [[UIImageView alloc]initWithFrame:CGRectMake((btnWidth-40)/2, (btnHeight-60)/3, 40, 40)];
        itemImgView.image = [UIImage imageNamed:imageArray[i]];
        [useBtn addSubview:itemImgView];
        
        UILabel  *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (btnHeight-60)/3*2+40, btnWidth, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = RGB(51, 51, 51);
        titleLabel.text = titleArray[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [useBtn addSubview:titleLabel];
        
        useBtn.tag = i+100;
        [useBtn addTarget:self action:@selector(moduleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeadView addSubview:useBtn];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(xx+btnWidth, yy, 1, btnHeight)];
        lineLabel.backgroundColor = kAPPTableViewLineColor;
        [_tableHeadView addSubview:lineLabel];
        
        }
    
    UILabel *bottomLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnHeight+AD_Height, kScreen_Width, 1)];
    bottomLineLabel.backgroundColor = kAPPTableViewLineColor;
    [_tableHeadView addSubview:bottomLineLabel];
}

#pragma mark - 请求相关
    //请求广告
-  (void)getPictureRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/banner",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSInteger result = [object[@"errCode"] integerValue];
        if (result==0)
            {
            NSDictionary *picDic = object;
            NSArray *keyArray = [picDic allKeys];
            
            NSMutableArray *picArray = [[NSMutableArray alloc]init];
            for (int i=0; i<keyArray.count; i++)
                {
                HomeModel *model = [[HomeModel alloc]init];
                model.imgurl = keyArray[i];
                model.contenturl = picDic[model.imgurl];
                [picArray addObject:model];
                }
            [self updateADPictureWithArray:picArray];
            }
        else
            {
            DLog(@"获取应用模块广告图片失败：%@",object[@"msg"]);
            }
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取应用模块广告图片失败：%@",error);
    } progress:nil];
}

    //请求公告
-  (void)getNotifyRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/notice",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取公告失败：%@",error);
    } progress:nil];
}

    //是否有告警
-  (void)getMessageRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/initApp/isAlarm",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        isHaveAlertMessage  = [string boolValue];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_bpTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"获取告警信息失败：%@",error);
        }];
}

    //安全运行多少天
-  (void)getSafetyRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/initApp/soDaynum",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    
    DLog(@"请求地址 urlString = %@?%@",urlString,[param serializeToUrlString]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     NSString *timeString = [BaseHelper getUserTimeStringWith:string];
     safeTimeString = timeString;
     DLog(@"安全运行时间 %@ %@",string,timeString);
         
         NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
         [_bpTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"获取安全运行失败：%@",error);
         }];
}

    //推广
-  (void)getAdverRequestAction
{
    adverArray = [[NSMutableArray alloc]init];
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/adver",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        NSArray *dataArray = (NSArray *)object;
        
        for (int i=0; i<dataArray.count; i++)
            {
            NSDictionary *useDic = dataArray[i];
            HomeAdverModel *model = [[HomeAdverModel alloc]initWithDictionary:useDic];
            [adverArray addObject:model];
            
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [_bpTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            }
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取推广失败：%@",error);
    } progress:nil];
}

    //菜单
-  (void)getMenuRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/initApp/menuOpen",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object) {
        
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取推广失败：%@",error);
    } progress:nil];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        {
        return 1;
        }
    if (section==1)
        {
        return adverArray.count;
        }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        {
        HomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMessageCell" forIndexPath:indexPath];
        if (isHaveAlertMessage==YES)
            {
            [cell setCellContentWithType:@"1" withDay:nil];
            }
        else
            {
            [cell setCellContentWithType:@"2" withDay:safeTimeString];
            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
    if (indexPath.section==1)
        {
        HomeAdverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeAdverCell" forIndexPath:indexPath];
        HomeAdverModel *itemModel = [adverArray objectAtIndex:indexPath.row];
        [cell setCellContentWithModel:itemModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
    return nil;
    
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        {
        return 115;
        }
    if (indexPath.section==1)
        {
        return 50+(SCREEN_WIDTH-60)/3+10;
        }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
        {
        return 10;
        }
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0)
        {
            //消息中心
        MessageViewController *vc = [[MessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
    if (indexPath.section == 1)
        {
        HomeAdverModel *item = [adverArray objectAtIndex:indexPath.row];
        PublicWebViewController *myWebVC = [[PublicWebViewController alloc]init];
        myWebVC.myUrl = [BaseHelper isSpaceString:item.url andReplace:@""];
        myWebVC.titleStr = @"";
        myWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebVC animated:YES];
        }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *imageContent = [cycleScrollView.imageContentsGroup objectAtIndex:index];
    if (imageContent.length>0)
        {
        PublicWebViewController *myWebVC = [[PublicWebViewController alloc]init];
        myWebVC.myUrl = [BaseHelper isSpaceString:imageContent andReplace:@""];
        myWebVC.titleStr = @"";
        myWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebVC animated:YES];
        }
    DLog(@"选择了图片是：%@",imageContent);
}

#pragma mark - NSNotificationCenter
- (void)updateADPictureWithArray:(NSArray *)allAds
{
    if (allAds.count>0)
        {
        NSMutableArray *allImageUrls = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *allImageContents = [NSMutableArray arrayWithCapacity:10];
        [allAds enumerateObjectsUsingBlock:^(HomeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allImageUrls addObject:obj.imgurl];
            [allImageContents addObject:obj.contenturl];
        }];
        self.adView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 分页控件位置
        self.adView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
        self.adView.imageURLStringsGroup = allImageUrls;
        self.adView.imageContentsGroup = allImageContents;
        self.adView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _adBgView.frame = CGRectMake(0, 0 , kScreen_Width, AD_Height);
        }
    else
        {
        _adBgView.frame = CGRectMake(0, 0, 0, 0.0000001);
        }
}

#pragma mark - getter
-(UIView *)tableHeadView
{
    if (!_tableHeadView)
        {
        CGFloat btnWidth = (kScreen_Width-3*1)/4;
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, AD_Height+btnWidth+1)];
        _tableHeadView.backgroundColor = [UIColor clearColor];
        [_tableHeadView addSubview:self.adBgView];
        }
    return _tableHeadView;
}

-(UIView *)adBgView
{
    if (!_adBgView)
        {
        _adBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, AD_Height)];
        _adBgView.backgroundColor = [UIColor clearColor];
        [_adBgView addSubview:self.adView];
        }
    return _adBgView;
}

- (SDCycleScrollView *)adView
{
    if (!_adView) {
        _adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, AD_Height) delegate:self placeholderImage:[UIImage imageNamed:@"main_ad_default"]];
    }
    return _adView;
}

- (UITableView *)bpTableView
{
    if (!_bpTableView) {
        _bpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT) style:UITableViewStyleGrouped];
        _bpTableView.delegate = self;
        _bpTableView.dataSource = self;
        _bpTableView.backgroundColor = kAppBackgrondColor;
        _bpTableView.tableFooterView = [[UIView alloc]init];
        [_bpTableView registerClass:[HomeMessageCell class] forCellReuseIdentifier:@"HomeMessageCell"];
        [_bpTableView registerClass:[HomeAdverCell class] forCellReuseIdentifier:@"HomeAdverCell"];
        _bpTableView.tableHeaderView = self.tableHeadView;
        _bpTableView.separatorColor = [UIColor clearColor];
        _bpTableView.showsVerticalScrollIndicator = NO;//隐藏垂直滚动条
    }
    return _bpTableView;
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
