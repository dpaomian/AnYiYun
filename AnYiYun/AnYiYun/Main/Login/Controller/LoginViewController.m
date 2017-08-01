//
//  LoginViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/19.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginManager.h"
#import "RootTabBarViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField          *_userNameField;
    UITextField          *_userPswField;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake((SCREEN_WIDTH-150)/2, 50, 50, 50);
    imageView.image = [UIImage imageNamed:@""];
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(imageView.frame.size.width+imageView.frame.origin.x, imageView.frame.origin.y, 100, 50);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    titleLabel.text = @"安易云";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(20, titleLabel.frame.size.height+titleLabel.frame.origin.y+20, SCREEN_WIDTH-40, 102)];
    inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputView];
    
        //用户名
    _userNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, 50)];
    _userNameField.borderStyle = UITextBorderStyleNone;
    _userNameField.delegate =self;
    UILabel *userNameLabel = [[UILabel alloc]init];
    userNameLabel.frame = CGRectMake(0, 0, 60, 50);
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.textColor = [UIColor blackColor];
    userNameLabel.font = [UIFont systemFontOfSize:16];
    userNameLabel.text = @"账号:";
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameField.leftView =  userNameLabel;
    _userNameField.leftViewMode = UITextFieldViewModeAlways;
    _userNameField.textColor = [UIColor blackColor];
    _userNameField.returnKeyType = UIReturnKeyNext;
    _userNameField.placeholder = @"用户名/手机号码";
    _userNameField.font = [UIFont systemFontOfSize:14];
    if ([PersonInfo shareInstance].loginTextAccount.length>0)
    {
        _userNameField.text = [PersonInfo shareInstance].loginTextAccount;
    }
    [inputView addSubview:_userNameField];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(0, 50, inputView.frame.size.width, 1);
    lineLabel.backgroundColor = kAPPTableViewLineColor;
    [inputView addSubview:lineLabel];
    
        //密码
    _userPswField = [[UITextField alloc]initWithFrame:CGRectMake(0, 51,_userNameField.frame.size.width, 50)];
    _userPswField.delegate =self;
    UILabel *pswLabel = [[UILabel alloc]init];
    pswLabel.frame = CGRectMake(0, 0, 60, 50);
    pswLabel.backgroundColor = [UIColor clearColor];
    pswLabel.textColor = [UIColor blackColor];
    pswLabel.font = [UIFont systemFontOfSize:16];
    pswLabel.textAlignment = NSTextAlignmentCenter;
    pswLabel.text = @"密码:";
    _userPswField.leftView =  pswLabel;
    _userPswField.leftViewMode = UITextFieldViewModeAlways;
    _userPswField.secureTextEntry = YES;//密码样式
    _userPswField.placeholder = @"登录密码";
    _userPswField.textColor = [UIColor blackColor];
    _userPswField.returnKeyType = UIReturnKeyDone;
    _userPswField.font = [UIFont systemFontOfSize:14];
    [inputView addSubview:_userPswField];
    
    UILabel *passWordlineLabel = [[UILabel alloc]init];
    passWordlineLabel.frame = CGRectMake(0, 101, inputView.frame.size.width, 1);
    passWordlineLabel.backgroundColor = kAPPTableViewLineColor;
    [inputView addSubview:passWordlineLabel];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, inputView.frame.origin.y +inputView.frame.size.height + 25 , inputView.frame.size.width, 40);
    [loginButton setBackgroundColor:kAPPBlueColor];
    loginButton.layer.cornerRadius = 3.0;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
    //登录
- (void)loginButtonClicked:(UIButton*)sender
{
    [_userNameField resignFirstResponder];
    [_userPswField resignFirstResponder];
    NSString *account = [BaseHelper filterNullObj:_userNameField.text];
    NSString *password =  [BaseHelper filterNullObj:_userPswField.text];
    if (!account.length)
        {
        [StatusBarOverlay initAnimationWithAlertString:@"帐号不能为空" theImage:nil];
        return;
        }
    else
        {
        [PersonInfo shareInstance].loginTextAccount = account;//保存账号为用户输入的值
        }
    if (!password.length)
        {
        [StatusBarOverlay initAnimationWithAlertString:@"密码不能为空" theImage:nil];
        return;
        }
        //缓存输入框内容
    NSString *passwordSHA = [password SHA256];
    [PersonInfo shareInstance].password = passwordSHA;
    [BaseCacheHelper setPersonInfo];
    
    [LoginManager loginWithAccount:account inVC:self completionBlockWithSuccess:^() {
        MAIN(^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            RootTabBarViewController *tabVC = [[RootTabBarViewController alloc] init];
            kWindow.rootViewController = tabVC;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    } failure:nil];
   
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField ==_userNameField)
        {
        [_userPswField becomeFirstResponder];
        }
    if (textField.returnKeyType == UIReturnKeyDone)
        {
        [self loginButtonClicked:nil];
        }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    return YES;
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
