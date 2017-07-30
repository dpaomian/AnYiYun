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
    
    self.title = @"能源管理";
    
    /*UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0f)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];*/
    __weak EnergyManagementViewController *ws = self;
    
    _stateView = [[YYSegmentedView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0f)];
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
    [_loadDetectionVC.view setFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-NAV_HEIGHT)];
    
    _energyConsumptionStatisticsVC = [[EnergyConsumptionStatisticsViewController alloc] init];
    
    _currentViewController = _loadDetectionVC;
    [self addChildViewController:_currentViewController];
    [self.view addSubview:_currentViewController.view];

    /*UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FilterCollectionView *collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f) collectionViewLayout:flowLayout];
    collectionView.selectedIndex = 0;
    [collectionView iteminitialization];
    collectionView.isFold = YES;
    collectionView.selectedIndex = 1;
    [collectionView iteminitialization];
    collectionView.foldHandle = ^(FilterCollectionView *mycollectionView, BOOL isFold){
        if (isFold) {
            mycollectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 34.0f);
        } else {
            mycollectionView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT);
        }
    };
    collectionView.choiceHandle = ^(FilterCollectionView *myCollectionView, id modelObject, NSInteger idx) {
        switch (idx) {
            case 1:
            {
                FilterCompanyModel * model = modelObject;
                if ([model.idF isEqualToString:@"all"]) {
                    [ws.conditionDic removeObjectForKey:@"firstCondition"];
                } else {
                    [ws.conditionDic setObject:model.companyName forKey:@"firstCondition"];
                }
                [ws getEnergyManagementData];
            }
                break;
            case 2:
            {
                BuildingModle * model = modelObject;
                if ([model.idF isEqualToString:@"all"]) {
                    [ws.conditionDic removeObjectForKey:@"secondCondition"];
                } else {
                    [ws.conditionDic setObject:model.name forKey:@"secondCondition"];
                }
                [ws getEnergyManagementData];
            }
                break;
            case 3:
            {
                SortModel * model = modelObject;
                if ([model.idF isEqualToString:@"500"]) {
                    [ws.conditionDic removeObjectForKey:@"thirdCondition"];
                } else{
                    [ws.conditionDic setObject:model.idF forKey:@"thirdCondition"];
                }
                [ws getEnergyManagementData];
            }
                break;
            case 4:
            {
                FilterCompanyModel * model = modelObject;
                [ws.conditionDic setObject:model.companyName forKey:@"fifthCondition"];
                [ws getEnergyManagementData];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:collectionView];*/
}

/*切换各个标签内容*/
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)nowController{
    nowController.view.frame = CGRectMake(0, 44.0f, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-44.0f);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
