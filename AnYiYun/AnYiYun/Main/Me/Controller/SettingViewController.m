    //
    //  SettingViewController.m
    //  AnYiYun
    //
    //  Created by wwr on 2017/7/19.
    //  Copyright © 2017年 wwr. All rights reserved.
    //

#import "SettingViewController.h"
#import "CompanyModel.h"
#import "UserInfoCell.h"
#import "MeCell.h"
#import "PublicWebViewController.h"
#import "ChangePwdViewController.h"
#import "LoginViewController.h"

#define TableFooterHelght 40

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *_sectionOneArray,*_sectionTwoArray;
}

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *settingTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view = self.settingTableView;
    
    [self getDataSource];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 切换账号后刷新视图
- (void)getDataSource
{
        //修改密码
    _sectionOneArray = @[@{@"icon":@"changepassword.png",
                           @"title":@"修改密码"}];
        //清除缓存
    _sectionTwoArray = @[@{@"icon":@"cleancache.png",
                           @"title":@"清除缓存"}];
    
    [_settingTableView reloadData];
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
        
        if([titleString isEqualToString:@"清除缓存"])
            {
                //设置缓存
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
        if ([textTitle isEqualToString:@"修改密码"])
            {
            ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            }
        else if ([textTitle isEqualToString:@"清除缓存"])
            {
            NSString *messageString = @"本次清除内容包括:\n 1.网络数据缓存; \n 2.所有图片缓存; \n   3.消息中心缓存。";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要清除本地缓存么？" message:messageString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            }
        }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
        {
        if (buttonIndex == 1)
            {
            DLog(@"确定");
            [MBProgressHUD showSuccess:@"清理完成"];
            }
        else
            {
            DLog(@"取消");
            }
        }
    else if (alertView.tag==101)
    {
        if (buttonIndex==1)
        {
            //    DLog(@"退出");
            [BaseCacheHelper releaseAllCache];
            
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.isLogOut=@"1";
            BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
            kWindow.rootViewController = navigation;
        }
    }
}


#pragma mark - Action

- (void)logoutAction
{
    
    NSString *message = @"您确认要\"注销登录\"么？";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 101;
    [alertView show];
}


#pragma mark - getter
- (UITableView *)settingTableView
{
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT) style:UITableViewStyleGrouped];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.backgroundView = nil;
        _settingTableView.backgroundColor = kAppBackgrondColor;
        _settingTableView.separatorColor = [UIColor clearColor];
        _settingTableView.tableFooterView = self.footerView;
    }
    return _settingTableView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, TableFooterHelght + 40)];
        UIButton *logoutButton = [[UIButton alloc] init];
        logoutButton.frame = CGRectMake(10, 20, kScreen_Width - 20,TableFooterHelght);
        [logoutButton setTitle:@"注销登录" forState:UIControlStateNormal];
        [logoutButton setBackgroundColor:[UIColor redColor]];
        logoutButton.layer.masksToBounds = YES;
        logoutButton.layer.cornerRadius = 5;
        logoutButton.userInteractionEnabled = YES;
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:logoutButton];
    }
    return _footerView;
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
