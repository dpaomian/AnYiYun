//
//  ShareViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "ShareViewController.h"
#import "YYQRCode.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分享";
    
    [self setShareView];
}

    //设置logo界面
- (void)setShareView
{
    NSString *useImageStr = BASE_PLAN_URL;
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
