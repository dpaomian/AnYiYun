//
//  PublicWebViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/21.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "PublicWebViewController.h"
#import <WebKit/WebKit.h>

@interface PublicWebViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *myWebView;
}

@end

@implementation PublicWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    if ([BaseHelper isSpaceString:_myUrl andReplace:@""].length>0)
    {
        [self setTheWebView];
    }
    
    if (![BaseHelper checkNetworkStatus])
    {
        DLog(@"网络异常 请求被返回");
        [BaseHelper waringInfo:@"网络异常,请检查网络是否可用！"];
    }

}

-(void)setRightBarItem {
    
}

- (void)setTheWebView
{
    if (myWebView)
        {
        [myWebView removeFromSuperview];
        myWebView = nil;
        }
    
    //给所有的链接都拼加当前用户
    NSString *myUrl = self.myUrl;
    myWebView = [[WKWebView alloc]init];
    myWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT);
    
    NSURL *url = [NSURL URLWithString:myUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
    myWebView.navigationDelegate = self;
    myWebView.UIDelegate = self;
    if ([_myUrl rangeOfString:@"http://"].location!=NSNotFound||[_myUrl rangeOfString:@"https://"].location!=NSNotFound)
        {
            //隐藏拖拽webview时上下的两个有阴影效果的subview
        for(UIView *subView in[myWebView subviews])
            {
            if([subView isKindOfClass:[UIScrollView class]])
                {
                for(UIView *shadowView in[subView subviews])
                    {
                    if([shadowView isKindOfClass:[UIImageView class]])
                        {
                        shadowView.hidden = YES;
                        }
                    }
                }
            }
            // 禁用UIWebView拖拽时的反弹效果
        [(UIScrollView*)[[myWebView subviews] objectAtIndex:0] setBounces:NO];
        [(UIScrollView*)[[myWebView subviews] objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
        [(UIScrollView*)[[myWebView subviews] objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
        }
    [self.view addSubview:myWebView];
}

#pragma mark - WKUIDelegate

/* 在JS端调用alert函数时，会触发此代理方法。JS端调用alert时所传的数据可以通过message拿到 在原生得到结果后，需要回调JS，是通过completionHandler回调 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    DLog(@"Alert %@", message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

    // JS端调用confirm函数时，会触发此方法
    // 通过message可以拿到JS端所传的数据
    // 在iOS端显示原生alert得到YES/NO后
    // 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView
runJavaScriptConfirmPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(BOOL result))completionHandler
{
    DLog(@"Confirm  %@", message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                 {
                                 completionHandler(NO);
                                 }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                 completionHandler(YES);
                                 }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    // JS端调用prompt函数时，会触发此方法
    // 要求输入一段文本
    // 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView
runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    defaultText:(nullable NSString *)defaultText
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    DLog(@"TextInput  %@", prompt);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - WKNavigationDelegate
    // WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
        //内存警告问题
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:
(WKNavigationAction *)navigationAction decisionHandler:
(void (^)(WKNavigationActionPolicy))decisionHandler
{
        //handleType=riskDelete
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    DLog(@"加载网页地址 ＝ %@",requestString);
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
}

    // WKNavigationDelegate 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    DLog(@"错误原因%@",[error description]);
}


@end

