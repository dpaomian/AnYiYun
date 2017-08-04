//
//  MeMainViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "MeMainViewController.h"
#import "CompanyModel.h"
#import "UserInfoCell.h"
#import "MeCell.h"
#import "PublicWebViewController.h"
#import "HistoryMessageViewController.h"
#import "SettingViewController.h"
#import "ShareViewController.h"
#import "DBDaoDataBase.h"

@interface MeMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_sectionOneArray,*_sectionTwoArray;
}

@property (nonatomic, strong) UITableView *meTableView;

@end

@implementation MeMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view = self.meTableView;

    [self getDataSource];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePersonInfo];
}

#pragma mark -

- (void)updatePersonInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/baseData/company",BASE_PLAN_URL];
    
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(NSDictionary *object)
     {
        NSInteger result = [object[@"errCode"] integerValue];
        if (result==0)
            {
            CompanyModel *model = [[CompanyModel alloc]initWithDictionary:object];
            [PersonInfo shareInstance].comId = model.companyId;
            [PersonInfo shareInstance].comName = model.companyName;
            [PersonInfo shareInstance].comLogoUrl = model.companyLogoUrl;
            [BaseCacheHelper setPersonInfo];
                //刷新第一个区
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_meTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        else
            {
            DLog(@"获取公司信息失败");
            }
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取获取公司信息失败：%@",error);
    } progress:nil];
    
    
    
}
#pragma mark - 切换账号后刷新视图
- (void)getDataSource
{
        //资讯 & 消息
    _sectionOneArray = @[@{@"icon":@"InformationIcon.png",
                           @"title":@"资讯"},
                         @{@"icon":@"MessageIcon.png",
                           @"title":@"消息"}];
        //设置 & 分享
    _sectionTwoArray = @[@{@"icon":@"SettingIcon.png",
                             @"title":@"设置"},
                           @{@"icon":@"ShareIcon.png",
                             @"title":@"分享"}];
    
    [_meTableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 64;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        {
        return _sectionOneArray.count;
        }
    else if (section == 2)
        {
        return _sectionTwoArray.count;
        }
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
    if (indexPath.section == 0)
        {
        UserInfoCell *meCell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!meCell) {
            meCell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            meCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return meCell;
        }
    else
        {
        MeCell *cell = (MeCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[MeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.bottomLineView.hidden = NO;
        NSDictionary *dic;
            if (indexPath.section == 1)
                {
                dic = [_sectionOneArray objectAtIndex:indexPath.row];
                if (indexPath.row==_sectionOneArray.count-1)
                    {
                    cell.bottomLineView.hidden = YES;
                    }
                }
            else if (indexPath.section == 2)
                {
                dic = [_sectionTwoArray objectAtIndex:indexPath.row];
                if (_sectionTwoArray.count>0)
                    {
                    if (indexPath.row==_sectionTwoArray.count-1)
                        {
                        cell.bottomLineView.hidden = YES;
                        }
                    }
                }
            NSString *titleString = dic[@"title"];
            NSString *typeString = @"";
            NSString *imageString = dic[@"icon"];
            if([titleString isEqualToString:@"消息"])
            {
                BOOL isUnRead = [[DBDaoDataBase sharedDataBase] isHaveNoReadHistoryMessageWithType:@""];
                if(isUnRead==YES)
                {
                    typeString = @"1";
                }
            }
            [cell setCellContentWithTitle:titleString withImageString:imageString withType:typeString];
        return cell;
        }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *textTitle =@"";
    NSDictionary *dic;
    if (indexPath.section == 1)
        {
        dic = [_sectionOneArray objectAtIndex:indexPath.row];
        textTitle =dic[@"title"];
        }
    else if (indexPath.section == 2)
        {
        dic = [_sectionTwoArray objectAtIndex:indexPath.row];
        textTitle =dic[@"title"];
        }
    
    if (textTitle.length>0)
    {
        if ([textTitle isEqualToString:@"咨讯"])
            {
            PublicWebViewController *vc = [[PublicWebViewController alloc] init];
            vc.titleStr = @"咨讯";
            vc.myUrl = @"http://101.201.108.246/index.html";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            }
    else if ([textTitle isEqualToString:@"消息"])
        {
        HistoryMessageViewController *vc = [[HistoryMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
    else if ([textTitle isEqualToString:@"设置"])
        {
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
    else if ([textTitle isEqualToString:@"分享"])
        {
        ShareViewController *vc = [[ShareViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - getter
- (UITableView *)meTableView
{
    if (!_meTableView) {
        _meTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT) style:UITableViewStyleGrouped];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        _meTableView.backgroundView = nil;
        _meTableView.backgroundColor = kAppBackgrondColor;
        _meTableView.separatorColor = [UIColor clearColor];
    }
    return _meTableView;
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
