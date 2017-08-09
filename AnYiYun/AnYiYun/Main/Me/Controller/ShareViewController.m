//
//  ShareViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "ShareViewController.h"
#import "YYQRCode.h"
#import "HomeModel.h"
#import "ShareAppView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *shareString;
@property (nonatomic, strong) ShareAppView *shareView;

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分享";

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"share_icon.png" hightImageName:@"share_icon.png" target:self action:@selector(rightBarButtonClick)];
    
    [self getPictureRequestAction];
    
}

-(void)rightBarButtonClick
{
    self.shareString = @"安易云让设备管理变得更简单！ http://a.app.qq.com/o/simple.jsp?pkgname=com.gdlion.gdc";
    
    [self.shareView showInView];
}

#pragma mark - 请求相关
//请求二维码
-  (void)getPictureRequestAction
{
    NSString *urlString = [NSString stringWithFormat:@"%@rest/busiData/er",BASE_PLAN_URL];
    NSDictionary *param = @{@"userSign":[PersonInfo shareInstance].accountID};
    [BaseAFNRequest requestWithType:HttpRequestTypeGet additionParam:@{@"isNeedAlert":@"1"} urlString:urlString paraments:param successBlock:^(id object)
     {
        NSDictionary *picDic = object;
        NSArray  *valueArray = [picDic allValues];
        
        if (valueArray.count>0)
        {
            NSString *imageUrl = [valueArray objectAtIndex:0];
            [self setShareViewWithUrl:imageUrl];
        }
         
    } failureBlock:^(NSError *error) {
        DLog(@"请求失败：%@",error);
    } progress:nil];
}
#pragma mark - UI相关
    //设置logo界面
- (void)setShareViewWithUrl:(NSString *)string
{
    NSString *useImageStr = [BaseHelper isSpaceString:string andReplace:BASE_PLAN_URL];
    DLog(@"自动生成二维码地址:  %@",useImageStr);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 40, 150, 150)];
    if (!iOS7Later)
        {
        imageView.image = [UIImage imageNamed:@"me_downCode.png"];
        }
    else
        {
        UIImage *qrCodeImage = [YYQRCode customColorImage:[YYQRCode resizeUIImageFormCIImage:[YYQRCode creatQRCodeWithString:useImageStr] withSize:512] withColor:UIColorFromRGB(0x000000)];
            //添加logo
        imageView.image = [YYQRCode addImageToQRCodeImage:qrCodeImage withImage:[UIImage imageNamed:@"AppIcon"] withScale:0.2];
        }
    [self.view addSubview:imageView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 40)];
    [titleLable setBackgroundColor:[UIColor clearColor]];
    [titleLable setTextColor:RGBA(51.0, 51.0, 51.0, 1.0)];
    [titleLable setFont:[UIFont systemFontOfSize:30]];
    [titleLable setText:@"让设备管理变得更简单"];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLable];
    
    
    UILabel *versionLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 20)];
    [versionLable setBackgroundColor:[UIColor clearColor]];
    [versionLable setTextColor:RGBA(51.0, 51.0, 51.0, 1.0)];
    [versionLable setFont:[UIFont systemFontOfSize:18]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"当前版本号为：V%@",app_Version];
    [versionLable setText:versionString];
    [versionLable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:versionLable];
    
}

#pragma mark -发送短信

-(void)shareToMessage
{
    [self showMessageView:nil title:nil body:self.shareString];
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

#pragma mark - 发送邮件

-(void)shareToEmail
{
    [self sendMailInApp];
}

#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass)
    {
        [BaseHelper waringInfo:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [BaseHelper waringInfo:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"分享"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    [mailPicker setBccRecipients:bccRecipients];

    NSString *emailBody = @"安易云让设备管理变得更简单！ http://a.app.qq.com/o/simple.jsp?pkgname=com.gdlion.gdc";
    [mailPicker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:mailPicker animated:YES completion:nil];

}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [BaseHelper waringInfo:msg];
}



#pragma mark - getter

- (ShareAppView *)shareView
{
    __weak typeof(self) weakSelf = self;
    if (!_shareView) {
        _shareView = [[ShareAppView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100) WithItems:nil];
        self.shareView.shareBlock = ^(NSString *nameString)
        {
            if ([nameString isEqualToString:@"短信"])
            {
               [weakSelf shareToMessage];
            }
            if ([nameString isEqualToString:@"邮件"])
            {
                [weakSelf shareToEmail];
            }
        };
        [self.shareView showInView];
    }
    return _shareView;
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
