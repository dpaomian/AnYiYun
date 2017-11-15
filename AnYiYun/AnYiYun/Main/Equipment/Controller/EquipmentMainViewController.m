//
//  EquipmentMainViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/20.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "EquipmentMainViewController.h"

@interface EquipmentMainViewController ()

@end

@implementation EquipmentMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*http://101.201.108.246/thinksaas/?username=15937109396&password=123456*/

    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * urlStr = [NSString stringWithFormat:@"http://101.201.108.246/thinksaas/?username=%@&password=%@",[BaseHelper isSpaceString:[PersonInfo shareInstance].loginTextAccount andReplace:@""],[BaseHelper isSpaceString:[PersonInfo shareInstance].password andReplace:@""]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.view = _webView;
    
    /*http://101.201.108.246/index.html*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![BaseHelper checkNetworkStatus])
    {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
    }
    
    //刷新是否有未读消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMessageIsRead" object:@""];
}

-(void)setRightBarItem {
    UIBarButtonItem *moreItem =[UIBarButtonItem itemWithImageName:@"right_more.png" hightImageName:@"right_more.png" target:self action:@selector(rightBarButtonAction)];
    UIBarButtonItem *refreshItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItems = @[moreItem, refreshItem];
}

- (void)refresh {
    NSString * urlStr = @"http://101.201.108.246/index.html";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
}

//    //点击弹出框
//-(void)rightBarButtonAction
//{
//    [self.tabBarController presentViewController:self.popNavVC animated:NO completion:nil];
//}

#pragma mark -
#pragma mark UIWebViewDelegate -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showMessage:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUD];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD showError:@"加载失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
