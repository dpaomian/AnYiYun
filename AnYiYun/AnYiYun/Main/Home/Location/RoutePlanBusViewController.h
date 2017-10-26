//
//  RoutePlanBusViewController.h
//  MAMapKit_2D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "ErrorInfoUtility.h"

#import "YYNaverBottomButton.h"
#import "YYNaverBottomView.h"

@interface RoutePlanBusViewController : UIViewController

@property (nonatomic, strong) AMapRoute *route;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

@property (nonatomic, strong) YYNaverBottomButton *mapBottomButton;
@property (nonatomic, strong) YYNaverBottomView *mapBottomListView;

@end
