//
//  BaseViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 2017/7/19.
//  Copyright © 2017年 Henan lion  m&c technology co.,ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "PopViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) BaseNavigationViewController *popNavVC;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightBarItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:NSStringFromClass([PopViewController class]) bundle:nil];
    _popNavVC = [[BaseNavigationViewController alloc] initWithRootViewController:popVC];
    _popNavVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _popNavVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)setRightBarItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"right_more.png" hightImageName:@"right_more.png" target:self action:@selector(rightBarButtonAction)];
}

//点击弹出框
-(void)rightBarButtonAction
{
    [self.tabBarController presentViewController:_popNavVC animated:NO completion:nil];
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
