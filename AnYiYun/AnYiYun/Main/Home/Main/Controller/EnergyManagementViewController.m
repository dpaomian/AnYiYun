//
//  EnergyManagementViewController.m
//  AnYiYun
//
//  Created by 韩亚周 on 17/7/24.
//  Copyright © 2017年 wwr. All rights reserved.
//

#import "EnergyManagementViewController.h"

@interface EnergyManagementViewController ()

@end

@implementation EnergyManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRequestAction];
    
    self.title = @"能源管理";
    
    _selectedInedex = 0;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44.0f)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    
        
    __weak EnergyManagementViewController *ws = self;
    
    _stateView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44.0f)];
    _stateView.backgroundColor = [UIColor yellowColor];
    _stateView.selectedIndex = 0;
    _stateView.titlesArray = @[@"负荷监测",@"能耗统计"];
    _stateView.itemHandle = ^(YYSegmentedView *stateView, NSInteger index) {
        if (index == stateView.selectedIndex) {
            return ;
        }else {
            stateView.selectedIndex = index;
            if (index == 0) {
                [ws replaceController:ws.currentViewController newController:ws.loadDetectionVC];
            } else {
                [ws replaceController:ws.currentViewController newController:ws.energyConsumptionStatisticsVC];
            }
        }
    };
    [self.view addSubview:_stateView];
    
    _loadDetectionVC = [[LoadDetectionViewController alloc] init];
    [_loadDetectionVC.view setFrame:CGRectMake(0, NAV_HEIGHT+44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-(NAV_HEIGHT+44.0f))];
    
    _energyConsumptionStatisticsVC = [[EnergyConsumptionStatisticsViewController alloc] init];
    
    _currentViewController = _loadDetectionVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FilterCollectionView *collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f+44.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 44.0f) collectionViewLayout:layout];
    collectionView.backgroundColor = UIColorFromRGBA(0x000000, 0.4f);
    [self.view addSubview:collectionView];
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    nowController.view.frame = CGRectMake(0, NAV_HEIGHT+44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-(NAV_HEIGHT+44.0f));
    [self addChildViewController:nowController];
    [self transitionFromViewController:oldController toViewController:nowController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [nowController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            _currentViewController = nowController;
        }else{
            _currentViewController = oldController;
        }
    }];
}

- (void)loadRequestAction {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/allOrg"];
    NSDictionary *parameters = @{@"userSign":[PersonInfo shareInstance].accountID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString
      parameters:parameters
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            NSLog(@" rest/busiData/allOrg %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
    
    NSString *urlString1 = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/deviceLocation"];
    NSDictionary *parameters1 = @{@"userSign":[PersonInfo shareInstance].accountID};
    [manager GET:urlString1
      parameters:parameters1
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            NSLog(@"rest/busiData/deviceLocation %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
    
    
    NSString *urlString2 = [NSString stringWithFormat:@"%@%@",BASE_PLAN_URL,@"rest/busiData/deviceOrder"];
    NSDictionary *parameters2 = @{@"userSign":[PersonInfo shareInstance].accountID};
    [manager GET:urlString2
      parameters:parameters2
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            NSLog(@"rest/busiData/deviceOrder %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
