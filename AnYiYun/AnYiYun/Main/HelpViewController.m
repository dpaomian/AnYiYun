//
//  HelpViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/8/2.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "HelpViewController.h"
#import "PopViewController.h"

@interface HelpViewController ()

@property (nonatomic, strong) PopViewController *popVC;

@end

@implementation HelpViewController


- (void)viewWillDisappear:(BOOL)animated {
    _backHandle();
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _popVC = [[PopViewController alloc] initWithNibName:NSStringFromClass([PopViewController class]) bundle:nil];
    _popVC.noHelp = YES;
    _popVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _popVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [MBProgressHUD showMessage:@"加载中..."];
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * urlStr = @"http://101.201.108.246/index.html";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.view = _webView;
}

-(void)setRightBarItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"right_more.png" hightImageName:@"right_more.png" target:self action:@selector(rightBarButtonAction)];
}

//点击弹出框
-(void)rightBarButtonAction
{
    [self presentViewController:_popVC animated:NO completion:nil];
}

#pragma mark -
#pragma mark UIWebViewDelegate -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUD];
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
