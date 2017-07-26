//
//  EquipmentMainViewController.m
//  AnYiYun
//
//  Created by wwr on 2017/7/20.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "EquipmentMainViewController.h"

@interface EquipmentMainViewController ()

@end

@implementation EquipmentMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * urlStr = @"http://101.201.108.246/index.html";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.view = _webView;
    
    /*http://101.201.108.246/index.html*/
}

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
