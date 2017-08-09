//
//  ChangePwdViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "ModifyPasswordCell.h"
#import "LoginViewController.h"

#define TableFooterHelght 40

@interface ChangePwdViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *passwordTableView;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"" hightImageName:@"" target:self action:@selector(rightBarButtonClick)];
    
    
    self.view = self.passwordTableView;
    [self addGesture];
}

-(void)rightBarButtonClick
{
    
}

#pragma mark - get dataSource



#pragma mark - Action

- (void)modifyAction
{
    DLog(@"确认修改密码");
    [self hiddenKeyBoard];
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    ModifyPasswordCell *cell0 = [self.passwordTableView cellForRowAtIndexPath:indexPath0];
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    ModifyPasswordCell *cell1 = [self.passwordTableView cellForRowAtIndexPath:indexPath1];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
    ModifyPasswordCell *cell2 = [self.passwordTableView cellForRowAtIndexPath:indexPath2];
    
    NSString *oldPassword = cell0.pwdTextField.text;
    NSString *newPassword = cell1.pwdTextField.text;
    NSString *confirmPassword = cell2.pwdTextField.text;
    
    if (!oldPassword.length) {
        [StatusBarOverlay initAnimationWithAlertString:@"请输入原密码" theImage:nil];
        return;
    }
    if (!newPassword.length) {
        [StatusBarOverlay initAnimationWithAlertString:@"请输入新密码" theImage:nil];
        return;
    }
    if (!confirmPassword.length) {
        [StatusBarOverlay initAnimationWithAlertString:@"请再次输入新密码" theImage:nil];
        return;
    }
    
    NSString *cachePassword = [PersonInfo shareInstance].password;
    if (![[oldPassword SHA256] isEqualToString:cachePassword]) {
        [StatusBarOverlay initAnimationWithAlertString:@"原密码输入不正确" theImage:nil];
        return;
    }
    
    if (![newPassword isEqualToString:confirmPassword]) {
        [StatusBarOverlay initAnimationWithAlertString:@"两次输入密码不一致" theImage:nil];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@rest/process/changePSW",BASE_PLAN_URL];
    
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID,
                            @"oldpsw":[PersonInfo shareInstance].password,
                            @"newpsw":[newPassword SHA256]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     BOOL isTure  = [string boolValue];
     if (isTure==YES)
        {
        [BaseHelper waringInfo:@"密码修改成功，请重新登录"];
        }
     else
         {
         [BaseHelper waringInfo:@"修改失败"];
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"请求修改密码失败：%@",error);
         }];
}

-(void)setAPPLogout
{
    
    [BaseCacheHelper releaseAllCache];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /*这里切换*/
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isLogOut=@"1";
        BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        kWindow.rootViewController = navigation;
    });
}
    //点击空白处隐藏键盘
- (void) tapGesturedDetected:(UITapGestureRecognizer *)recognizer
{
    if (![recognizer.view isKindOfClass:[UITextField class]]) {
        [self hiddenKeyBoard];
    }
}
#pragma mark - Private Methods
- (void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hiddenKeyBoard
{
    for (int i=0; i<3; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        ModifyPasswordCell *cell = [self.passwordTableView cellForRowAtIndexPath:path];
        [cell.pwdTextField resignFirstResponder];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    ModifyPasswordCell *cell = (ModifyPasswordCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[ModifyPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row == 0){
        cell.leftTextLabel.text = @"原密码：";
        cell.pwdTextField.placeholder = @"请输入原始密码";
    }else if (indexPath.row == 1){
        cell.leftTextLabel.text = @"新密码：";
        cell.pwdTextField.placeholder = @"请输入新密码";
    }else if(indexPath.row == 2){
        cell.leftTextLabel.text = @"确认密码：";
        cell.pwdTextField.placeholder = @"请再次输入新密码";
    }
    return cell;
}


#pragma mark - getter
- (UITableView *)passwordTableView
{
    if (!_passwordTableView) {
        _passwordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT) style:UITableViewStyleGrouped];
        _passwordTableView.delegate = self;
        _passwordTableView.dataSource = self;
        _passwordTableView.tableFooterView = self.footerView;
        _passwordTableView.separatorColor = [UIColor clearColor];
    }
    return _passwordTableView;
}


- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, TableFooterHelght + 40)];
        UIButton *modifyButton = [[UIButton alloc] init];
        modifyButton.frame = CGRectMake(10, 20, kScreen_Width - 20,TableFooterHelght);
        [modifyButton setTitle:@"提交修改" forState:UIControlStateNormal];
        [modifyButton setBackgroundColor:kAPPBlueColor];
        modifyButton.layer.masksToBounds = YES;
        modifyButton.layer.cornerRadius = 5;
        modifyButton.userInteractionEnabled = YES;
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modifyButton addTarget:self action:@selector(modifyAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:modifyButton];
    }
    return _footerView;
}

@end

